#!/bin/bash
set -euo pipefail
pushd $(dirname "$0")/..

# Check if a profile parameter is provided, default to 'dev' if not
PROFILE=${1:-dev}

export DOJO_WORLD_ADDRESS=$(cat ./manifests/$PROFILE/manifest.json | jq -r '.world.address')
export ACTIONS_ADDRESS=$(cat ./manifests/$PROFILE/manifest.json | jq -r '.contracts[] | select(.name == "chain_monsters::systems::actions::actions" ).address')

echo "---------------------------------------------------------------------------"
echo world : $DOJO_WORLD_ADDRESS
echo actions : $ACTIONS_ADDRESS
echo "---------------------------------------------------------------------------"

# enable system -> models authorizations
MODELS=("Player" "Game" "Team" "Monster" "MonsterPosition")
ACTIONS=($ACTIONS_ADDRESS)

command="sozo --profile $PROFILE auth grant --world $DOJO_WORLD_ADDRESS --wait writer "
for model in "${MODELS[@]}"; do
    for action in "${ACTIONS[@]}"; do
        command+="$model,$action "
    done
done
eval "$command"

echo "Default authorizations have been successfully set."