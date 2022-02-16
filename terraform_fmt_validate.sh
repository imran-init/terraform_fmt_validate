#!/bin/bash

set -e

set -o pipefail

echo "Echoing ENV Vars."
echo "FILES: ${FILES}"
echo "OPERATION: ${OPERATION}"

if ! { [[ "${OPERATION}" == "fmt" || "${OPERATION}" == "validate" || "${OPERATION}" == "" ]]; }; then
    echo 'Invalid value for OPERATION. Valid values are "fmt", "validate", and "".'
    exit 1;
fi

if [[ "${OPERATION}" == "fmt" || "${OPERATION}" == "" ]]; then
    for dir in $(echo "${FILES}" | xargs -n1 dirname | sort -u | uniq); do
    echo "--> Running 'packer fmt -check -recursive' in directory 'repository/${dir}'"
    pushd "repository/${dir}" >/dev/null
    packer fmt -check -recursive . || exit $?
    popd >/dev/null
    done
    # exit ${FMT_ERROR}
fi

if [[ "${OPERATION}" == "validate" || "${OPERATION}" == "" ]]; then
    for dir in $(echo "${FILES}" | xargs -n1 dirname | sort -u | uniq); do
    echo "--> Running 'packer validate -syntac-only' in directory 'repository/${dir}'"
    pushd "repository/${dir}" >/dev/null
    packer validate -syntax-only . || exit $?
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