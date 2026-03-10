# nu-version: 0.102.0

# Native command tree for Go. Most Go flags use single-dash long options
# (for example `-race`), which Nushell externs cannot model today, so this
# file focuses on command and subcommand recognition.

extern "go" [
  ...args
]

extern "go bug" [
  ...args
]

extern "go build" [
  ...args
]

extern "go clean" [
  ...args
]

extern "go doc" [
  ...args
]

extern "go env" [
  ...args
]

extern "go fix" [
  ...args
]

extern "go fmt" [
  ...args
]

extern "go generate" [
  ...args
]

extern "go get" [
  ...args
]

extern "go help" [
  ...args
]

extern "go install" [
  ...args
]

extern "go list" [
  ...args
]

extern "go mod" [
  ...args
]

extern "go run" [
  ...args
]

extern "go telemetry" [
  ...args
]

extern "go test" [
  ...args
]

extern "go tool" [
  ...args
]

extern "go version" [
  ...args
]

extern "go vet" [
  ...args
]

extern "go work" [
  ...args
]

extern "go help buildconstraint" [
  ...args
]

extern "go help buildjson" [
  ...args
]

extern "go help buildmode" [
  ...args
]

extern "go help c" [
  ...args
]

extern "go help cache" [
  ...args
]

extern "go help environment" [
  ...args
]

extern "go help filetype" [
  ...args
]

extern "go help go.mod" [
  ...args
]

extern "go help goauth" [
  ...args
]

extern "go help gopath" [
  ...args
]

extern "go help goproxy" [
  ...args
]

extern "go help importpath" [
  ...args
]

extern "go help module-auth" [
  ...args
]

extern "go help modules" [
  ...args
]

extern "go help packages" [
  ...args
]

extern "go help private" [
  ...args
]

extern "go help testflag" [
  ...args
]

extern "go help testfunc" [
  ...args
]

extern "go help vcs" [
  ...args
]

extern "go mod download" [
  ...args
]

extern "go mod edit" [
  ...args
]

extern "go mod graph" [
  ...args
]

extern "go mod init" [
  ...args
]

extern "go mod tidy" [
  ...args
]

extern "go mod vendor" [
  ...args
]

extern "go mod verify" [
  ...args
]

extern "go mod why" [
  ...args
]

extern "go telemetry local" [
  ...args
]

extern "go telemetry off" [
  ...args
]

extern "go telemetry on" [
  ...args
]

extern "go tool asm" [
  ...args
]

extern "go tool cgo" [
  ...args
]

extern "go tool compile" [
  ...args
]

extern "go tool cover" [
  ...args
]

extern "go tool fix" [
  ...args
]

extern "go tool link" [
  ...args
]

extern "go tool preprofile" [
  ...args
]

extern "go tool vet" [
  ...args
]

extern "go work edit" [
  ...args
]

extern "go work init" [
  ...args
]

extern "go work sync" [
  ...args
]

extern "go work use" [
  ...args
]

extern "go work vendor" [
  ...args
]
