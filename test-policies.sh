#!/bin/bash

# Test script for OPNSense Conftest Policies
# This script validates the policies against example configurations

set -e

echo "🔥 OPNSense Conftest Policy Validation"
echo "======================================"

# Check if conftest is installed
if ! command -v conftest &> /dev/null; then
    echo "❌ Conftest is not installed. Please install it first:"
    echo "   brew install conftest"
    echo "   # or"
    echo "   go install github.com/open-policy-agent/conftest@latest"
    exit 1
fi

echo "✅ Conftest found: $(conftest --version)"
echo ""

# Test good configuration (should pass)
echo "🧪 Testing compliant configuration..."
echo "File: examples/opnsense-config.json"
echo "Expected: All policies should pass"
echo "----------------------------------------"

if conftest test examples/opnsense-config.json; then
    echo "✅ Compliant configuration passed all policies!"
else
    echo "❌ Compliant configuration failed - this indicates a policy issue"
    exit 1
fi

echo ""

# Test bad configuration (should fail)
echo "🧪 Testing non-compliant configuration..."
echo "File: examples/bad-config.json"
echo "Expected: Multiple policy violations"
echo "----------------------------------------"

if conftest test examples/bad-config.json; then
    echo "❌ Non-compliant configuration passed - policies may be too lenient"
    exit 1
else
    echo "✅ Non-compliant configuration correctly failed policies!"
fi

echo ""

# Test individual policy files
echo "🧪 Testing individual policy files..."
echo "======================================"

policies=(
    "policy/firewall_rules.rego"
    "policy/interface_config.rego"
    "policy/vpn_security.rego"
    "policy/network_security.rego"
    "policy/access_control.rego"
    "policy/system_config.rego"
    "policy/compliance.rego"
)

for policy in "${policies[@]}"; do
    echo "Testing $policy..."
    if opa fmt --diff "$policy"; then
        echo "✅ $policy is properly formatted"
    else
        echo "❌ $policy has formatting issues"
        exit 1
    fi
    
    if opa test "$policy"; then
        echo "✅ $policy syntax is valid"
    else
        echo "❌ $policy has syntax errors"
        exit 1
    fi
done

echo ""
echo "🎉 All tests passed!"
echo ""
echo "Usage examples:"
echo "  conftest test your-config.json"
echo "  conftest test --config conftest.yaml your-config.json"
echo "  conftest test --policy policy/ your-config.json"