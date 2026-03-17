# DevOps Handoff

## Package
- Name: `@quantum-sec/node-red-contrib-quantum`
- Version: `1.0.0-quantum-sec.1`
- Target runtime: Node-RED `4.1.5`
- Node.js requirement: `>=18.0.0` (validated on Node 18 and Node 20)

## Current validation status
- `npm run lint` passes
- `npm test` passes
- GitHub Actions passes on Node 18 and Node 20
- `npm audit --omit=dev` reports `0 vulnerabilities`
- live Node-RED 4.1.5 runtime smoke test completed successfully
- all 27 nodes load in the editor without startup/deploy-time deprecation warnings

## Python runtime requirements
- repository-local `venv` is used
- Python `3.9+` required
- required Python packages:
  - `qiskit`
  - `qiskit-aer`
  - `qiskit-algorithms`
  - `matplotlib`
  - `pylatexenc`
  - `qiskit-finance`
  - `qiskit-optimization`

## Packaging and publish settings
- scoped package name is configured
- package publish access is set to `restricted`
- package contents were verified with `npm pack --dry-run`
- `.npmrc` is gitignored to avoid committing registry credentials

## Important known limitation
- `Shors` currently uses a compatibility fallback rather than a real modern Qiskit Shor implementation
- this limitation must remain documented in deployment/release notes

## Required DevOps actions
1. configure the internal npm registry for the `@quantum-sec` scope
2. authenticate publishing environment to the internal registry
3. publish approved build from `master`
4. validate install from the internal registry in a clean Node-RED 4.1.5 environment
5. run final staging smoke test with target deployment settings
6. confirm Python/Qiskit package versions in the deployment environment
7. attach release/version metadata to deployment records

## Recommended staging validation
1. install the package from the internal registry
2. confirm all 27 nodes appear in the palette
3. open representative node edit dialogs
4. deploy a simple circuit flow
5. deploy a simulator flow
6. verify Python-backed execution works in the target environment
7. confirm expected behavior for Grovers, Script, and Shors-related flows

## Security notes
- production use should prefer isolated runtime environments
- dependency review should continue through Dependabot and registry scanning
- remaining `npm audit` findings are currently low-severity dev-only issues in test tooling, not runtime package issues

## References
- `README.md`
- `ARCHITECTURE.md`
- `.github/workflows/node.js.yml`

## Final release artifact
- Git tag: `v1.0.0-quantum-sec.1`
- Tarball: `quantum-sec-node-red-contrib-quantum-1.0.0-quantum-sec.1.tgz`
- SHA256: `6611db5e8adf66a3428d67279eecef8f87d1b2af3e55211c69ef02cdb6d3130c`
