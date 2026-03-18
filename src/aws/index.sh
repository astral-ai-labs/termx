module "☁️" "AWS"

helper "aws-login" "🔑" "Login to AWS SSO (e.g. aws-login dev-profile)" << 'EOF'
    if [ -z "$1" ]; then
        echo "Usage: aws-login <profile>"
        echo "Example: aws-login sesha-dev"
        aws-profiles
        return 1
    fi
    echo "Attempting AWS SSO login with profile: $1 ..."
    aws sso login --profile "$1" && export AWS_PROFILE="$1"
    echo "AWS_PROFILE set to $1"
EOF

helper "aws-profiles" "📋" "List all AWS profiles" << 'EOF'
    echo "Available AWS CLI profiles:"
    aws configure list-profiles
EOF

helper "aws-current" "👤" "Show current AWS profile" << 'EOF'
    if [ -z "$AWS_PROFILE" ]; then
        echo "No AWS_PROFILE is currently set"
        echo "Hint: Use 'aws-login <profile>' to activate one"
    else
        echo "Current AWS_PROFILE: $AWS_PROFILE"
    fi
EOF

helper "aws-clear" "🗑️" "Clear AWS profile" << 'EOF'
    unset AWS_PROFILE
    echo "AWS_PROFILE cleared"
EOF
