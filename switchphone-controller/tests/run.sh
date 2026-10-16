#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
out=$(mktemp -d)
trap 'rm -rf "$out"' EXIT
java com.sun.tools.javac.Main -d "$out" android-app/app/src/main/java/com/switchphone/controller/ControllerState.java android-app/app/src/main/java/com/switchphone/bluetooth/DiagnosticDescriptor.java android-app/app/src/main/java/com/switchphone/protocol/NintendoDescriptor.java android-app/app/src/main/java/com/switchphone/protocol/NintendoProtocol.java android-app/app/src/main/java/com/switchphone/bluetooth/PairingFlow.java android-app/app/src/main/java/com/switchphone/controller/InputRouter.java tests/ControllerStateTest.java tests/NintendoProtocolTest.java android-app/app/src/main/java/com/switchphone/controller/PairingPulse.java tests/PairingFlowTest.java tests/InputRouterTest.java tests/PairingPulseTest.java android-app/app/src/main/java/com/switchphone/bluetooth/BondMonitor.java tests/BondMonitorTest.java android-app/app/src/main/java/com/switchphone/bluetooth/BondFailure.java tests/BondFailureTest.java
java com.sun.tools.javac.Main -cp "$out" -d "$out" android-app/app/src/main/java/com/switchphone/bluetooth/LinkExperiment.java tests/LinkExperimentTest.java android-app/app/src/main/java/com/switchphone/bluetooth/HidProfile.java tests/HidProfileTest.java
java -cp "$out" ControllerStateTest
java -cp "$out" NintendoProtocolTest
java -cp "$out" PairingFlowTest
java -cp "$out" InputRouterTest
java -cp "$out" PairingPulseTest
java -cp "$out" BondMonitorTest
java -cp "$out" BondFailureTest
java -cp "$out" LinkExperimentTest
java -cp "$out" HidProfileTest
java com.sun.tools.javac.Main -cp "$out" -d "$out" android-app/app/src/main/java/com/switchphone/layouts/ControllerGeometry.java tests/ControllerGeometryTest.java tests/ReconnectFlowTest.java
java -cp "$out" ControllerGeometryTest
java -cp "$out" ReconnectFlowTest
java com.sun.tools.javac.Main -cp "$out" -d "$out" tests/NintendoOptionalTrafficTest.java
java -cp "$out" NintendoOptionalTrafficTest
