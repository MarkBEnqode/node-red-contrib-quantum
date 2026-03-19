# @enqoding/node-red-contrib-quantum

[![Platform](https://img.shields.io/badge/platform-Node--RED-red)](https://nodered.org)
[![CI](https://github.com/MarkBEnqode/node-red-contrib-quantum/actions/workflows/node.js.yml/badge.svg)](https://github.com/MarkBEnqode/node-red-contrib-quantum/actions/workflows/node.js.yml)

Quantum circuit and algorithm nodes for Node-RED 4.x security orchestration workflows.

## Fork status

This repository is an internally maintained fork of the upstream `node-red-contrib-quantum` project.

- Upstream project: `node-red-quantum/node-red-contrib-quantum`
- Fork namespace target: `@enqoding/node-red-contrib-quantum`
- Current fork version: `1.0.0-quantum-sec.1`

This fork modernizes the project for Node-RED 4.1.5, Node.js 18+, updated linting and test tooling, current Python/Qiskit compatibility work, and CI validation on Node 18 and 20.

## Compatibility matrix

| Component | Supported version |
| --- | --- |
| Node-RED | 4.1.5 |
| Node.js | >= 18.0.0 |
| Recommended Node.js | 20.x |
| Python | 3.9+ |
| Tested in CI | Node 18, Node 20 |
| Python-backed runtime | local venv created by postinstall |

## What is included

This package provides Node-RED nodes for:

- building quantum circuits
- manipulating qubits and registers
- applying common quantum gates
- simulating and visualizing circuit output
- running packaged algorithm nodes such as Grover's and Shor's-related flows

The package currently exposes 27 Node-RED nodes through the `node-red` package metadata.

## Installation

### From a local clone

1. Install Node.js 18 or later.
2. Install Python 3.9 or later.
3. Clone this repository.
4. From the repository root, run `npm ci`.

This installs Node.js dependencies and then runs postinstall, which prepares a local Python virtual environment and installs the required Python packages.

### Start Node-RED locally

Run `npm run start`.

### Development commands

- `npm run lint`
- `npm test`
- `npm run coverage`

## Python environment

The project uses a repository-local virtual environment created by:

- `bin/pyvenv.sh` on Bash-compatible shells
- `bin/pyvenv.ps1` on Windows PowerShell

The Python setup currently installs these packages:

- `qiskit`
- `qiskit-aer`
- `qiskit-algorithms`
- `matplotlib`
- `pylatexenc`
- `qiskit-finance`
- `qiskit-optimization`

## Security considerations

This fork is intended for controlled engineering use inside security orchestration workflows.

Key security expectations:

- use pinned dependencies via `package-lock.json`
- run regular `npm audit` and dependency scanning
- validate Python package versions in controlled environments
- review flow inputs carefully before executing Python-backed nodes
- treat IBM Quantum and external service credentials as sensitive secrets
- prefer isolated runtime environments for production deployments

## Migration notes from upstream v0.4.0

This fork is not a drop-in runtime upgrade without review.

Notable changes from the upstream baseline include:

- Node-RED target updated from older 1.x assumptions to Node-RED 4.1.5
- Node.js baseline updated to 18+
- ESLint, Mocha, Chai, and Node-RED test helper modernized
- CI added for Node 18 and 20
- Python/Qiskit compatibility behavior updated for current environments
- cross-platform npm scripts updated using `cross-env`

Before migrating existing flows from upstream v0.4.0:

1. verify the runtime is using Node-RED 4.1.5
2. verify Node.js is 18 or 20
3. recreate the Python virtual environment
4. retest simulator and algorithm flows
5. review any IBM Quantum connectivity assumptions
6. validate output formatting for Script, Grovers, and Shors-related flows

## Known limitations

The fork is functional, but there are important limitations to document:

- `Shors` currently uses a compatibility fallback rather than a real modern Qiskit Shor implementation
- IBM Quantum related behavior may require additional work depending on upstream API changes
- Python and Qiskit package compatibility should be validated in each deployment environment
- live editor/runtime validation has been completed for Node-RED 4.1.5 on Node.js 20, but should still be repeated in the final target staging environment before release

## Testing status

Current local validation baseline:

- lint passes
- test suite passes
- CI passes on Node 18 and Node 20


## Live Runtime Validation

The fork has been smoke-tested successfully in a live Node-RED 4.1.5 editor/runtime environment on Node.js 20.

Validated manually:
- all 27 nodes loaded in the palette
- `quantum` category displayed 24 nodes
- `quantum algorithms` category displayed 3 nodes
- node edit dialogs opened correctly
- deploy succeeded in the Node-RED editor
- no startup or deploy-time deprecation warnings were observed during this validation

## Architecture

See `ARCHITECTURE.md` for a higher-level description of the quantum-classical flow model, node interaction patterns, and Python execution boundaries.

## Contributing

Internal fork maintenance should prefer small, auditable changes with test coverage.

Recommended workflow:

1. branch from `master`
2. make focused changes
3. run lint and tests locally
4. push branch and verify GitHub Actions
5. merge only after CI passes

## Release and internal publishing

This package is intended to be published to an internal npm registry under the scoped name `@enqoding/node-red-contrib-quantum`.

Current release baseline:

- package name: `@enqoding/node-red-contrib-quantum`
- version: `1.0.0-quantum-sec.1`
- publish access: `restricted`
- runtime package audit status: `npm audit --omit=dev` reports 0 vulnerabilities
- remaining `npm audit` findings are currently low-severity dev-only issues in test tooling

Before publishing:

1. confirm the target internal registry URL for the `@enqoding` scope
2. authenticate with the internal registry in the publishing environment
3. run `npm run lint`
4. run `npm test`
5. run `npm pack --dry-run`
6. verify staging validation for the target Node-RED 4.1.5 environment
7. publish using the internal registry workflow approved by DevOps

Important notes:

- do not publish this package to the public npm registry
- keep the `Shors` compatibility fallback documented in release notes and deployment notes
- repeat live runtime validation in the final staging environment before production rollout
- coordinate version bumps and release tagging with DevOps and platform owners


## Acknowledgements

This project is based on the original `node-red-contrib-quantum` work by the upstream authors and contributors.

See `AUTHORS` and the upstream repository history for original project attribution.