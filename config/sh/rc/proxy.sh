# shellcheck disable=SC1091

# PROXY_HOST / PROXY_PORT may be set in the machine-local layer
# (~/.config/local/profile/).  These are only fallbacks.
_proxy_url() {
  printf 'http://%s:%s' "${PROXY_HOST:-127.0.0.1}" "${PROXY_PORT:-7890}"
}

proxy_on() {
  local url
  url="$(_proxy_url)"
  export http_proxy="$url"
  export https_proxy="$url"
  export all_proxy="$url"
  export HTTP_PROXY="$url"
  export HTTPS_PROXY="$url"
  export ALL_PROXY="$url"
  export no_proxy="localhost,127.0.0.1,::1,.local"
  export NO_PROXY="localhost,127.0.0.1,::1,.local"
  echo "Proxy enabled. $url"
}

proxy_off() {
  unset http_proxy https_proxy all_proxy
  unset HTTP_PROXY HTTPS_PROXY ALL_PROXY
  unset no_proxy NO_PROXY
  echo "Proxy disabled."
}

# apt exists on Linux only.
if [ "$(uname -s)" = "Linux" ]; then
  papt() {
    local url
    url="$(_proxy_url)"
    apt -o "Acquire::http::proxy=$url" -o "Acquire::https::proxy=$url" "$@"
  }
fi
