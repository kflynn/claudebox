# Claudebox

One of the creepiest things about the push toward agents like Claude Code
is that allowing an autonomous, nonhuman, pseudointelligent agent to
_pretend to be you_ on your machine is supposed to be OK. That's a scary
proposition, given that I basically don't let _other humans_ do that.

There are alternatives, of course, with the safest one being "run the
agent on a dedicated machine" and a close second being "run the agent in
a container as a sandbox". These both come with logistical issues, but
those issues tend to be tedious rather than hard: you have to set up the
machine or the image, copy in tools, get your source code mounted, etc.

This turns out to be exactly the thing that a dev container already does,
though. And the Linkerd project has a fine dev container...

## `claudebox`

So. `claudebox` is how I've been running Claude Code on my Mac recently.

- The `claudebox` Docker image starts with the Linkerd dev image (which
  includes a decent set of tools) and adds the `claude` CLI and some
  scripts that I also find handy.

- The `claudebox` script fires up the `claudebox` image in a container
  with your source code mounted (and various bits of environment set up),
  then runs `claude` for you in _fully permissive_ mode, so it can run
  _anything_ without asking if it's OK. This is the point.

Inside the `claudebox` container, `$HOME` is `/home/code`, and your
source directory appears as `/work`.

## Installation

Copy this repo's `claudebox` script to somewhere on your `$PATH` and make
sure it's executable.

## Usage

Run `claudebox --help` to see the usage statement, but:

- `claudebox` starts running Claude Code for your current directory
- `claudebox /path/to/other/dir` starts running Claude Code for `/path/to/other/dir` (just like you'd `cd`'d there first)
- `claudebox --shell` drops you into a shell rather than into Claude Code.

## Other Setup

Your `$HOME/.claudebox` directory can also contain things to customize
Claudebox.

### Environment

`$HOME/.claudebox/environment`, if present, must have lines of the form
`NAME=VALUE`:

```
MY_AUTHORIZATION_TOKEN=my-auth-token-value
MY_REAL_NAME=Flynn
```

Each of these will be added to the environment of the running
`claudebox`, so they'll be available to anything in the container.

### Additional Mountpoints

`$HOME/.claudebox/mounts`, if present, must have lines that look like
Docker volume mounts:

```
-v /tmp/my-yaml-files:/home/code/yaml
-v /Users/flynn/auth-tokens:/home/code/.auth-tokens
```

These will be passed through when starting the `claudebox` container.
Note that, at present, shell-variable interpolation is _not_ supported.

### Additional Scripts

`$HOME/.claudebox/scripts`, if present, must contain executable scripts.
Each will be linked into `/home/code/bin`.
