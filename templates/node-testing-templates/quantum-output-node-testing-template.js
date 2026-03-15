const util = require('util');
const testUtil = require('../test-util');
const nodeTestHelper = testUtil.nodeTestHelper;
const {FlowBuilder} = require('../flow-builder');
const xyzGateNode = require('../../nodes/quantum/xyz-gate/xyz-gate.js'); // Replace with the import for the node that is being tested.
const snippets = require('../../nodes/snippets.js');

const flow = new FlowBuilder();

// REMEMBER TO REMOVE x IN xit BEFORE EACH TEST CASE IN ORDER TO ENABLE TESTS FOR THE NODE.
describe('xyzGateNode', function() { // Replace with the imported node.
  beforeEach(function(done) {
    nodeTestHelper.startServer(done);
  });

  afterEach(function(done) {
    flow.reset();
    nodeTestHelper.unload();
    nodeTestHelper.stopServer(done);
  });

  xit('load node', function(done) {
    // Replace below with the imported node.
// Use the name from registerType in the node's HTML file.
    testUtil.isLoaded(xyzGateNode, 'xyz-gate', done);
  });

  xit('execute command', function(done) {
    // Replace with the snippet and parameters needed to execute the node.
let command = util.format(snippets.XYZ_GATE);
    flow.add('quantum-circuit', 'n0', [['n1']], {structure: 'qubits', outputs: '1', qbitsreg: '1', cbitsreg: '1'});
    // Replace with the node name from registerType.
// Add any required default node properties.
    flow.add('xyz-gate', 'n1', [['n2']]);
    flow.addOutput('n2');

    testUtil.commandExecuted(flow, command, done);
  });
});
