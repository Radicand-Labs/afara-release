# `afara layers`

Shows which layer of the product this repository's project is, and which other projects are linked to it as its other layers.

```sh
afara layers
afara layers list [--layer <layer>]
afara layers link <layer> [project]
afara layers unlink <layer>
```

## Layers

Each project is one layer of the product: `frontend`, `backend`, `fullstack`, `mobile`, `cli`, `library` or `other`. A project's own layer is set in the dashboard (**Settings → Layer**). Projects created before layers existed have none until someone sets it.

A project can link other projects as its layers, so a backend knows which web app and which mobile app it serves. A link names one of `frontend`, `backend`, `mobile`, `cli` or `library`, and each layer holds at most one project.

A `fullstack` project counts as both a frontend and a backend. A project with no layer, or with `other`, never counts as any layer.

## `afara layers`

Shows this repository's project, its layer, and the projects linked to it.

```sh
afara layers
```

**Output:**

```
Shop API  (shop-api, backend)

  frontend  Checkout Web (checkout-web)  acme/checkout-web  linked 2026-10-02 by dana
  mobile    Shop App (shop-app)          acme/shop-app      linked 2026-10-05 by dana

Not linked: cli, library. Link one with `afara layers link <layer>`.
```

- The first line is the project's name, then its slug and layer. With no layer set, a line below it says to set one in the dashboard.
- Each linked layer shows the linked project, its repository, and when and by whom it was linked.
- **Not linked** lists the layers with nothing linked. The project's own layer is left out: a backend is not offered a backend, and a fullstack project is offered neither a frontend nor a backend.

## `afara layers list`

Lists every project you can see, with its layer.

```sh
afara layers list [--layer <layer>]
```

| Flag | Description |
| --- | --- |
| `--layer <layer>` | Only the projects that can be this layer: `frontend`, `backend`, `mobile`, `cli` or `library`. A `fullstack` project matches both `frontend` and `backend`. |

**Examples:**

```sh
afara layers list
afara layers list --layer frontend
```

**Output:**

```
LAYER      PROJECT       SLUG          REPOSITORY
backend    Shop API      shop-api      acme/shop-api
frontend   Checkout Web  checkout-web  acme/checkout-web
fullstack  Admin         admin         acme/admin
mobile     Shop App      shop-app      acme/shop-app
no layer   Legacy        legacy        acme/legacy
```

Projects are grouped by layer, then sorted by name. Projects with no layer come last.

`list` needs you to be signed in, but not to be in a repository. Use it to find the slug to pass to `link`.

## `afara layers link`

Links another project as one of this project's layers. Only project owners can link.

```sh
afara layers link <layer> [project]
```

| | Description |
| --- | --- |
| `layer` | **Required.** `frontend`, `backend`, `mobile`, `cli` or `library`. |
| `project` (optional) | The slug of the project to link. Without it, Afara offers the projects that can be that layer. |

**Examples:**

```sh
afara layers link frontend checkout-web
afara layers link frontend                # choose from the projects that can be a frontend
```

**Output:**

```
Linked Checkout Web as Shop API's frontend (acme/checkout-web)
```

- **Without a slug**, a terminal shows a numbered list of the projects that can be that layer, leaving out this project. Type a number or a slug. With no terminal (CI, a pipe, or the interactive shell), the list is printed with a reminder to pass the slug, and nothing is linked.
- **Linking a layer that is already linked** replaces the project linked there.
- If no other project can be that layer, `link` stops: `no other project is a mobile. Set a project's layer in the dashboard, then link it`.
- The dashboard checks every link. Linking a project to itself, linking the project's own layer, or linking a project whose layer does not fit is refused, and Afara prints the dashboard's reason.
- If you are not an owner of the project: `only a project owner can change its layers`.

## `afara layers unlink`

Removes the project linked as one of this project's layers. Only project owners can unlink.

```sh
afara layers unlink <layer>
```

**Example:**

```sh
afara layers unlink frontend
```

**Output:**

```
Unlinked Shop API's frontend
```

## In the interactive shell

| Slash command | Equivalent |
| --- | --- |
| `/layers` | `afara layers` |
| `/layers list` | `afara layers list` |
| `/layers list --layer <layer>` | `afara layers list --layer <layer>` |
| `/layers link <layer> <project>` | `afara layers link <layer> <project>` |
| `/layers unlink <layer>` | `afara layers unlink <layer>` |

There is no project list to choose from in the shell. `/layers link frontend` with no slug prints the projects that can be a frontend: run it again with the slug, for example `/layers link frontend checkout-web`.

---

[← Afara CLI documentation](README.md)
