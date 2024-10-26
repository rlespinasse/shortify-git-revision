# Shortify git revision

> [!NOTE]
> A GitHub Action that generates shortened Git revision identifiers from full-length commit hashes and exposes them as environment variables.

## Features

- Converts full Git revisions into their shortened form
- Validates revision format and handles invalid inputs
- Provides both full and shortened revisions as environment variables
- Configurable error handling for invalid revisions

## Behavior

- Creates `<NAME>` and `<NAME>_SHORT` environment variables for valid revisions
- Environment variables are only set when the input revision is non-empty and valid
- Handles invalid revisions based on configuration:
  - Fails by default (controlled by `continue-on-error` input)
  - Can be customized using `short-on-error` input to override default behavior

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

When providing a `revision` through the revision input, the action will use this environment variable name to store the shortened hash.

If no environment variable is specified, the action automatically creates one using the `name` input (converted to uppercase) to store the provided `revision` value.

### `revision`

The revision to shortify into an environment variable named `<NAME>_SHORT`.

This input is _Optional_.

### `continue-on-error`

If the input is set to `true`, this action will not fail on a bad revision

The default value is `false`.

### `short-on-error`

If the input is set to `true`, this action will short a bad revision

The default value is `false`.

> [!WARNING]
>
> - If this input is set to `true`, the input `continue-on-error` input will be ignored.
> - If this input is set to `true`, the input `length` input is mandatory.

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
