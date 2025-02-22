#!/usr/bin/env bash
#
# Copyright 2025 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Make our include guard clean against set -o nounset.
test -n "${CI_CLOUDBUILD_BUILDS_LIB_MACOS_SH__:-}" || declare -i CI_CLOUDBUILD_BUILDS_LIB_MACOS_SH__=0
if ((CI_CLOUDBUILD_BUILDS_LIB_MACOS_SH__++ != 0)); then
  return 0
fi # include guard

source module ci/lib/io.sh

function google_time() {
  curl -sI google.com | tr -d '\r' | sed -n 's/Date: \(.*\)/\1/p'
}

function os::cpus() {
  sysctl -n hw.logicalcpu
}

function os::prefetch() {
  echo "@remotejdk11_macos//:jdk"
}

io::log_h1 "Machine Info"
printf "%10s %s\n" "host:" "$(date -u -R)"
printf "%10s %s\n" "google:" "$(google_time)"
printf "%10s %s\n" "kernel:" "$(uname -v)"
printf "%10s %s\n" "os:" "$(sw_vers | xargs)"
printf "%10s %s\n" "arch:" "$(arch)"
printf "%10s %s\n" "cpus:" "$(os::cpus)"
printf "%10s %s\n" "mem:" "$(($(sysctl -n hw.memsize) / 1024 / 1024 / 1024)) GB"
printf "%10s %s\n" "term:" "${TERM-}"
printf "%10s %s\n" "bash:" "$(bash --version 2>&1 | head -1)"
printf "%10s %s\n" "bash:" "${BASH_VERSION:-}"
printf "%10s %s\n" "clang:" "$(clang --version 2>&1 | head -1)"
printf "%10s %s\n" "brew:" "$(brew --version 2>&1 | head -1)"
echo >&2
