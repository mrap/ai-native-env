#!/usr/bin/env bash
# Local end-to-end test for the ai-native-env installer, in clean Docker containers.
# Proves install.sh works driven by both bash and zsh, producing a valid zsh setup.
# Run from the repo root:  bash tests/e2e/run.sh
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
IMAGE="anv-e2e:latest"

echo "==> Building test image"
docker build -q -t "$IMAGE" -f "$SCRIPT_DIR/Dockerfile" "$SCRIPT_DIR" >/dev/null

RC=0
for interp in bash zsh; do
  echo ""
  echo "================ matrix cell: installer interpreter = $interp ================"
  # Fresh container each cell; repo mounted read-only (installer writes only to $HOME).
  # --network none: a correct install needs no network (deps stubbed, repo mounted),
  # so any accidental clone fallback fails loudly here instead of masking the bug.
  docker run --rm \
    --network none \
    -u tester -e HOME=/home/tester \
    -v "$REPO_DIR":/repo:ro \
    "$IMAGE" \
    zsh /repo/tests/e2e/assert.sh "$interp" || RC=1
done

echo ""
if [ $RC -eq 0 ]; then
  echo "==> ALL E2E SCENARIOS PASSED"
else
  echo "==> E2E FAILURES (see above)"
fi
exit $RC
