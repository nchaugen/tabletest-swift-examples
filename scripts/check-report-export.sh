#!/bin/sh
set -eu

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    echo "Usage: $0 <tabletest-reporter-cli.jar> [tabletest-swift checkout]" >&2
    exit 2
fi

examples=$(cd "$(dirname "$0")/.." && pwd)
package="$examples/../tabletest-swift"
if [ "$#" -eq 2 ]; then
    package=$2
fi
package=$(cd "$package" && pwd)
reporter=$1
mkdir -p "$examples/.build"
run=$(mktemp -d "$examples/.build/report-export.XXXXXX")
echo "Result bundle and report: $run"
project="$run/project"
mkdir -p "$project"
cp -R "$examples/Examples" "$examples/ExamplesTests" "$examples/Examples.xcodeproj" "$project/"

# The examples use a released package. Point the staged project at the checkout under test.
python3 - "$project/Examples.xcodeproj/project.pbxproj" "$package" <<'PY'
import json
from pathlib import Path
import re
import sys

path, package = sys.argv[1:]
project = Path(path)
source = project.read_text()
source, replacements = re.subn(
    r'isa = XCRemoteSwiftPackageReference;\s*repositoryURL = "https://github\.com/nchaugen/tabletest-swift\.git";'
    r'\s*requirement = \{[^}]+\};',
    lambda _: f"isa = XCLocalSwiftPackageReference;\n\t\t\trelativePath = {json.dumps(package, ensure_ascii=False)};",
    source,
)
if replacements != 1:
    sys.exit("Could not replace the TableTest package reference in the staged examples project")
project.write_text(source)
PY

if xcodebuild test -project "$project/Examples.xcodeproj" -scheme Examples \
    -destination 'platform=macOS' -derivedDataPath "$run/DerivedData" -skipMacroValidation \
    -resultBundlePath "$run/results.xcresult" \
    'SWIFT_ACTIVE_COMPILATION_CONDITIONS=DEBUG TABLETEST_REPORTING PROBE_XCRESULT' \
    > "$run/xcodebuild.log" 2>&1; then
    echo "Expected the fixture to fail on purpose" >&2
    exit 1
else
    status=$?
    if [ "$status" -ne 65 ] || [ ! -d "$run/results.xcresult" ]; then
        tail -40 "$run/xcodebuild.log" >&2
        exit 1
    fi
fi

swift run --package-path "$package" tabletest-export "$run/results.xcresult" "$run/export"
java -jar "$reporter" -f html -i "$run/export/yaml" -o "$run/report"

python3 - "$run" <<'PY'
import json
from pathlib import Path
import sys

run = Path(sys.argv[1])
tables = json.loads((run / "export/joined-results.json").read_text())

def cases(method):
    table, = [table for table in tables if table["methodName"] == method]
    return table["cases"]

ordinary = cases("knowsALeapYearForEachExample")
assert len(ordinary) == 10 and all(case["status"] == "Passed" for case in ordinary), ordinary
assert all(
    case["displayName"] == case["xcodeDisplayName"]
    for table in tables for case in table["cases"] if "xcodeDisplayName" in case
), tables
leap = cases("leapYear")
assert [case["status"] for case in leap] == ["Passed", "Failed", "Skipped", "Failed"], leap
assert leap[0]["displayName"] == "Check leap years (Year = 2004) [1.1]", leap
assert leap[3]["displayName"] == "Check leap years (Year = 2004) [2.1]", leap
collision = cases("sameNameWithinRow")
assert [case["status"] for case in collision] == ["Passed", "Failed"], collision
assert [case["displayName"] for case in collision] == ["[a, b] | 2 [1.1]", "[a, b] | 2 [1.2]"], collision
disabled, = cases("disabledTable")
assert disabled["status"] == "Skipped", disabled

pages = run / "report/result-bundle-probe"
collision_page = (pages / "names-collide-within-one-row.html").read_text()
assert "of 2 scenarios broken" in collision_page
assert "[a, b] | 2 [1.2]" in collision_page
assert 'class="coll set"' in collision_page
disabled_page = (pages / "disabled-table.html").read_text()
assert "Skipped: 1. Test skipped: Disabled on purpose" in disabled_page
print(f"Verified the report and exported outcomes for {len(tables)} tables.")
PY
