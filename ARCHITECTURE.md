# ARCHITECTURE

## Overview

`@enqode/node-red-contrib-quantum` provides Node-RED nodes that let security orchestration flows build quantum circuits, execute quantum-inspired algorithms, and exchange results with classical workflow steps.

This fork modernizes the original upstream module for Node-RED 4.1.5, Node.js 18+/20, and current Python/Qiskit environments. The architecture keeps Node-RED as the orchestration layer while delegating quantum-specific execution to a Python-backed runtime boundary.

The design goal is to make quantum operations composable inside larger automation flows while keeping execution behavior observable, testable, and constrained.

---

## Execution Models

The module supports two main execution models.

### 1. Circuit Composition Flows

In circuit composition flows, Node-RED messages progressively build up a circuit across multiple nodes. A flow may:

- create a circuit
- add qubits or classical bits
- apply gates
- apply measurement operations
- execute the circuit
- forward results to downstream classical logic

In this model, the Node-RED message acts as the transport for circuit context and execution state.

### 2. Algorithm Flows

In algorithm flows, a Node-RED node acts as a higher-level operation that invokes an algorithm-oriented Python path. These nodes may encapsulate logic such as search, optimization, finance, or factorization-related behavior.

This model is less about incrementally constructing a circuit in the editor and more about invoking a defined quantum or quantum-inspired routine and returning structured output to the flow.

---

## Main Components

## 1. Node-RED Node Layer

The Node-RED layer exposes the palette nodes and handles editor/runtime registration through `RED.nodes.registerType(...)`.

Responsibilities include:

- receiving incoming messages
- validating required message/config inputs
- updating node status in the editor
- forwarding normalized payloads to shared helpers
- emitting results and errors back into the flow

This layer must remain compatible with Node-RED 4.1.5 lifecycle expectations, including `this.send(...)`, `this.status(...)`, and `this.error(...)`.

## 2. Shared Runtime and State Helpers

Shared helpers coordinate common state and execution behaviors used by multiple nodes.

Responsibilities include:

- maintaining circuit readiness checks
- normalizing payload structure
- reducing duplication across node implementations
- handling common simulator and execution plumbing
- protecting flows from race conditions and malformed state transitions

The `isCircuitReady` behavior introduced during modernization is part of this layer’s responsibility and helps avoid premature execution against incomplete circuit state.

## 3. Python Execution Boundary

Quantum execution is delegated across a Node.js-to-Python boundary.

Responsibilities include:

- spawning Python-backed operations when required
- isolating Qiskit-specific execution from Node-RED runtime code
- allowing the JavaScript layer to remain thin and orchestration-focused
- converting Python output into flow-friendly message structures

This boundary is a critical integration point because the Node-RED runtime remains JavaScript-based while the quantum implementation depends on Python packages and Qiskit APIs.

## 4. Qiskit-Backed Execution Layer

The Python layer provides the actual circuit and algorithm execution environment.

Responsibilities include:

- circuit simulation
- algorithm execution
- backend/library imports
- translation of execution results into stable output forms
- compatibility handling for upstream behavior that no longer maps cleanly to current Qiskit APIs

This layer currently includes compatibility workarounds where modern Qiskit behavior differs from the original upstream assumptions.

---

## Quantum-Classical Message Flow

The architecture follows a hybrid message flow pattern.

### Typical flow

1. A Node-RED message enters a quantum node.
2. The node reads message/config inputs.
3. Shared helpers validate or update quantum state.
4. If needed, the node invokes Python-backed execution.
5. Python/Qiskit returns results to the Node.js runtime.
6. The node emits a normalized message for downstream classical processing.
7. Downstream flows can log, branch, alert, persist, or correlate the result with other security events.

### Design intent

This lets quantum operations behave as building blocks inside broader security orchestration flows rather than isolated scripts. A quantum step can therefore participate in:

- decision pipelines
- enrichment pipelines
- experiment/simulation flows
- future AI or policy-driven automations

---

## Execution Boundaries and Trust Zones

The module should be understood as operating across distinct boundaries.

### Node-RED Runtime Boundary

The Node-RED runtime is the orchestration and control plane. It is responsible for message routing, node lifecycle, and operator visibility.

### Local Python Environment Boundary

The Python environment is an execution dependency and must be treated as a controlled runtime component. Its package set directly affects correctness, reproducibility, and security posture.

### External Service Boundary

Some upstream concepts assumed integration patterns tied to IBM Quantum and older APIs. Those integrations are now subject to API drift, credential changes, and service-level evolution. Where such integrations exist, they must be treated as external trust boundaries with explicit configuration and validation.

---

## Error Handling Model

The module uses a layered error model.

### Node-Level Errors

Node implementations should surface runtime failures through Node-RED mechanisms such as:

- `this.status(...)`
- `this.error(...)`
- structured message output where appropriate

### Helper-Level Errors

Shared helpers should reject invalid state early and consistently so that node implementations do not silently continue with broken circuit context.

### Python Execution Errors

Python-side failures should be captured and translated into actionable Node-RED-visible errors. This includes import failures, environment issues, unsupported algorithm paths, and simulator/runtime exceptions.

### Operator Goal

The operator should be able to distinguish between:

- invalid flow input
- node/state misuse
- Python environment failure
- Qiskit compatibility limitation
- external API/service limitation

---

## Security Considerations

This fork is intended for security orchestration environments, so traceability and dependency control matter.

### Dependency Control

- Node.js dependencies should remain pinned through `package-lock.json`.
- Python dependencies should be version-controlled and documented clearly.
- High and critical vulnerabilities should be remediated promptly.

### Execution Safety

- Treat inbound flow data as untrusted until validated.
- Avoid hidden execution behavior across the Node.js/Python boundary.
- Keep Python invocation paths explicit and reviewable.

### Reproducibility

- The same flow should behave consistently across supported Node.js and Python versions.
- CI should validate Node 18 and Node 20 behavior.
- Python environment setup should remain scripted and repeatable.

### Auditability

Because this module is intended for security workflows, quantum operations should be easy to trace within larger classical automations. Error messages, result structures, and node status updates should support operational review and compliance needs.

---

## Known Architectural Limitations

## 1. Shors Compatibility Fallback

The current `Shors` implementation is not backed by a modern native Qiskit Shor workflow. It currently uses a compatibility fallback to preserve functional behavior in the forked module.

This limitation must remain documented clearly and should not be represented as a full modern Shor implementation.

## 2. Upstream API Assumptions

The original upstream project targeted older Node-RED, Node.js, and Qiskit ecosystems. Some upstream assumptions no longer map directly to current library behavior.

## 3. Python Environment Sensitivity

The module depends on a working local Python environment and compatible Qiskit packages. Environment drift can cause failures even when the Node.js side is unchanged.

## 4. External Quantum Service Drift

Any service-backed or IBM Quantum-oriented functionality may require additional adaptation over time due to authentication, SDK, or endpoint changes.

---

## Recommended Maintenance Approach

To keep this fork production-ready:

### 1. Keep Runtime Compatibility Current

- validate against maintained Node-RED 4.x releases
- keep Node 18 and Node 20 CI coverage active
- review deprecation warnings in real editor/runtime testing

### 2. Treat Python as a First-Class Dependency Surface

- keep setup scripts current
- document exact package requirements
- verify compatibility when Qiskit packages change

### 3. Preserve Strong Test Coverage

- keep regression coverage on circuit-building nodes
- maintain Python-backed integration tests
- expand smoke tests for real Node-RED runtime behavior

### 4. Document Behavior Changes Explicitly

- record divergence from upstream
- keep migration notes up to date
- document known limitations rather than hiding compatibility fallbacks

### 5. Review Security Regularly

- run audit tooling routinely
- monitor GitHub security alerts and Dependabot results
- keep CI and dependency policies active

---

## Summary

This module is best understood as a hybrid Node-RED and Python/Qiskit integration layer. Node-RED provides orchestration, visibility, and composition. Python provides the quantum execution substrate. Shared helpers bridge the two and protect flow behavior from invalid state and compatibility drift.

That separation is what makes the fork maintainable: the orchestration surface can evolve with Node-RED, while the execution layer can be adapted as Qiskit and related Python tooling continue to change.