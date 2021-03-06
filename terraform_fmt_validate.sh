#!/bin/bash

set -e

set -o pipefail

echo "Echoing ENV Vars."
echo "DIRS: ${DIRS}"
echo "OPERATION: ${OPERATION}"

if ! { [[ "${OPERATION}" == "fmt" || "${OPERATION}" == "validate" || "${OPERATION}" == "" ]]; }; then
    echo 'Invalid value for OPERATION. Valid values are "fmt", "validate", and "".'
    exit 1;
fi

if [[ "${OPERATION}" == "fmt" || "${OPERATION}" == "" ]]; then
    for dir in $(echo "${DIRS}" | sort -u | uniq); do
    echo "--> Running 'terraform fmt -check -diff -recursive' in directory 'repository/${dir}'"
    pushd "repository/${dir}" >/dev/null
    terraform fmt -check -diff || exit $?
    popd >/dev/null
    done
    # exit ${FMT_ERROR}
fi

if [[ "${OPERATION}" == "validate" || "${OPERATION}" == "" ]]; then
    for dir in $(echo "${DIRS}" | sort -u | uniq); do
    echo "--> Running 'terraform validate' in directory 'repository/${dir}'"
    pushd "repository/${dir}" >/dev/null
    terraform validate . || exit $?
    popd >/dev/null
    done
    # exit ${VALIDATE_ERROR}

fi

# echo "Exiting with error. OPERATION value is invalid."

# exit 1


# EXIT_CODE=0

# 

# echo "Checking packer config formatting..."
# packer fmt -check -recursive "cdcd



# echo "Running syntax validtion for the provided repo."
# IFS=$'\n' 
# # for dir in $(find "$1" -iname "*.pkr.hcl"  | xargs -d '\n' dirname | sort | uniq); do
# for dir in $(find "$1" -iname "*.pkr.hcl"  -exec dirname {} \; | sort | uniq); do
#     echo "Running packer validate -syntax-only in ${dir}"
#     pwd
#     pushd "${dir}" > /dev/null
#     packer validate -syntax-only .
#     popd
# done