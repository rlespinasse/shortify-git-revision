# Shortify git revision

> Github Action to shortify a git revision

Produce short revision environment variable based on the input one.

## Usage

- Shortify an environment variable

  ```yaml
  - uses: rlespinasse/shortify-git-revision@v1.x
    with:
      name: GITHUB_SHA
      revision: value_to_slugify
  ```

  Will make available

  - `GITHUB_SHA_SHORT`

- Shortify any revision

  ```yaml
  - uses: rlespinasse/slugify-value@v1.x
    with:
      name: SOME_REVISION
      revision: 88428f56bd9d2751c47106bedfd148162dfa50b8
  ```

  Will make available

  - `SOME_REVISION`
  - `SOME_REVISION_SHORT`
