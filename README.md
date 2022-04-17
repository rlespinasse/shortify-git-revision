# Shortify git revision

> Github Action to shortify a git revision

Produce short revision environment variable based on the input one.

If a revision is a bad revision, this action will produce an error message and fail depending on `continue-on-error` input (This behavior can be override with `short-on-error` input).
`<NAME>`, and `<NAME>_SHORT` environment variable will only be available if the revision is not empty and valid.

## Usage

- Shortify an environment variable

  ```yaml
  - uses: actions/checkout@v3
  - uses: rlespinasse/shortify-git-revision@v1
    with:
      name: GITHUB_SHA
  ```

  Will make available

  - `GITHUB_SHA_SHORT`

- Shortify an environment variable with prefix

  ```yaml
  - uses: actions/checkout@v3
  - uses: rlespinasse/shortify-git-revision@v1
    with:
      name: GITHUB_SHA
      prefix: CI_
  ```

  Will make available

  - `CI_GITHUB_SHA`
  - `CI_GITHUB_SHA_SHORT`

- Shortify any revision

  ```yaml
  - uses: actions/checkout@v3
  - uses: rlespinasse/shortify-git-revision@v1
    with:
      name: SOME_REVISION
      revision: 88428f56bd9d2751c47106bedfd148162dfa50b8
  ```

  Will make available

  - `SOME_REVISION`
  - `SOME_REVISION_SHORT`

- Shortify a revision with a specific length

  ```yaml
  - uses: actions/checkout@v3
  - uses: rlespinasse/shortify-git-revision@v1
    with:
      name: SIZED_REVISION
      revision: 88428f56bd9d2751c47106bedfd148162dfa50b8
      length: 10
  ```

  Will make available

  - `SIZED_REVISION`
  - `SIZED_REVISION_SHORT` (with value `88428f56bd`)

- Shortify without publishing the environment variables

  ```yaml
  - uses: actions/checkout@v3
  - uses: rlespinasse/shortify-git-revision@v1
    with:
      name: GITHUB_SHA
  ```

  Will **not** make available

  - `GITHUB_SHA_SHORT`

## Inputs

### `name`

If used with `revision` input, it's the name of the environment variable containing the revision to shortify.
Otherwise, the `name` input will be used (in upper case) to define a environment variable containing the `revision` input value.

### `revision`

The revision to shortify into an environment variable named `<NAME>_SHORT`.

This input is _Optional_.

### `continue-on-error`

If the input is set to `true`, this action will not fail on a bad revision

The default value is `false`.

### `short-on-error`

If the input is set to `true`, this action will short a bad revision

The default value is `false`.

> If this input is set to `true`, the input `continue-on-error` input will be ignored.
> If this input is set to `true`, the input `length` input is mandatory.

### `prefix`

The value will be prepend to each generated variable.

This input is _Optional_.

### `length`

the `short` sha produce will have the length defined by the input.

This input is _Optional_.

## Outputs

| Output   | Description                 |
| -------- | --------------------------- |
| revision | The revision to be shortify |
| short    | Revision Short              |
