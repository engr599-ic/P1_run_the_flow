<!-- Author: Joseph Bellahcen <josbella@iu.edu> -->

# Contributing to SAIL-IN Repositories

This document is a set of guidelines for contributing to SAIL-IN repositories,
covering best practices for writing code and collaborating with Git. Please
read this document before making a contribution. It will make the development
experience easier for the whole team and help us to produce high-quality,
organized code.

## Table of Contents

- [Rationale](#rationale)
- [Asking Questions & Reporting Bugs](#asking-questions--reporting-bugs)
- [Pull Requests](#pull-requests)
- [Deliverable Requests](#deliverable-requests)
- [Code Style](#code-style)
- [Re-Using Code](#re-using-code)

## Rationale

Working on a large software project is a lot like working in a large kitchen.
A kitchen is a busy place with many chefs working together to produce a
high-quality product. Each chef has their own unique expertise and style, but
they all must use the same appliances, utensils, and recipes to create
high-quality dishes consistent with the restaurant's brand. Likewise, software
developers need to follow contribution guidelines, consistent coding styles,
and a standardized Git contribution workflow to produce code that is
maintainable and high-quality.

## Asking Questions & Reporting Bugs

The first destination for questions and bug reports should be the GitHub Issues
page. This is preferred over other communication channels such as e-mail or
Slack because it is public (internal), indexable, and supports rich text
threads with code snippets, images, and other attachments. This makes it easy
for other users to find answers to common questions and for maintainers to
track and resolve bugs.

Before opening an issue, please search through existing open and closed issues
in case your question has already been answered. If it has not, please open a
new issue and fill out the template with as much detail as possible. This will
help us to understand your question or bug report and respond to it quickly.

To create a bug report, please follow the template and provide as much detail
as possible. Consider including the following information:

- Target branch, which should be level with the latest release
- Stack traces, logs, or other error messages
- OS, Platform and Version (e.g. `AlmaLinux 8.8`)
- Interpreter, compiler, SDK, etc. versions
- Detailed steps to reproduce issue

## Pull Requests

All contributions to SAIL-IN repositories should be made through GitHub pull
requests. This includes bug fixes, new features, and documentation updates.
In fact, if you try to push directly to the `main` branch, GitHub will
reject your push and instruct you to open a pull request instead. Pull requests
must also be linked to an issue. If you are fixing a bug, please link to the
issue that describes the bug. If you are adding a new feature, please open an
issue first to discuss the feature with the maintainers and get approval.

Before opening a pull request, please ensure that your branch is up-to-date
and named according to the following convention:

```
<type>/<short-description>
```

Valid types include:
- `bugfix`
- `doc`
- `feature`
- `refactor`
- `release`
- `test`

Fill out the pull request template with as much detail as possible. This will
help us to understand your contribution and review it quickly. It also helps
if the pull request is small and focused on a single feature or bug fix. If
you have multiple contributions, please open multiple pull requests. **Do not**
combine multiple unrelated changes into a single pull request. **Do not**
re-use old branches or pull requests for new contributions.

In order to close a pull request, you must have at least one approving review.
This review can be from a maintainer or another contributor. If you are a
maintainer, please review pull requests promptly. If you are a contributor,
please review other pull requests in addition to opening your own. This will
help us to review pull requests quickly and keep the project moving forward.

## Deliverable Requests

Oftentimes, a deliverable will be requested from a repository. This could be
a compiled binary, synthesized Verilog netlist, or other artifact. In order to
ensure that the deliverable is consistent and reproducible, please follow the
following steps:

1. Create a new branch from the latest release branch
1. Update the README with instructions for building the deliverable
1. Create a pull request and link to the issue that requested the deliverable
1. Wait for the pull request to be approved and merged
1. Create a new release from the merged pull request
1. Tag the release with the deliverable name and version
1. Upload the deliverable to the release
1. Close the issue

If deliverables are not versioned, it will be difficult to track how they
change over time. If they are not tagged, it will be difficult to find the
correct version. If they are not uploaded to the release, it will be difficult
to find them at all. If they are not linked to an issue, it will be difficult
to know why they were created in the first place. Always keep in mind the
famous last words:

> "It worked on my machine!" ¯\\_(ツ)_/¯

## Code Style

Code style is important for maintainability and readability. It is also
important for consistency. If everyone on the team follows the same style,
it will be easier to read and understand each other's code. This will make
it easier to collaborate and review pull requests. It will also make it
easier to maintain the code in the future. If you are working on a project
that already has a style guide, please follow it. If you are working on a
project that does not have a style guide, please follow the style guide for
the language you are using:

- C/C++: [Google C++ Style Guide](https://google.github.io/styleguide/cppguide.html)
- Python: [PEP 8](https://peps.python.org/pep-0008)
- Verilog: [lowRISC Style Guide](https://github.com/lowRISC/style-guides/blob/master/VerilogCodingStyle.md)

### General Guidelines

- Use descriptive variable names
- Name functions using verbs and nouns, e.g. `getFoo()`, `setBar()`
- Use comments to explain complex code
- Use whitespace to separate code into logical blocks
- Limit line length to 80 characters*

*This is a soft limit. If a line is longer than 80 characters, it is not
the end of the world. However, it is a good idea to keep lines short so that
they are easy to read on a variety of devices and screen sizes.

### Linting & Formatting Tools

Linting and formatting tools can help to enforce code style and catch errors
before they are committed. If you are working on a project that already has
linting and formatting tools, please use them. If you are working on a project
that does not have linting and formatting tools, please consider adding them.

- C/C++: [cpplint](https://github.com/cpplint/cpplint)
- Python: [black](https://github.com/psf/black)
- Verilog: [verible-verilog-lint](https://github.com/chipsalliance/veriblecpp)

## Re-Using Code

### Git Submodules

Git submodules are a powerful way to include external code into a project, and
they are preferred over direct copying of source files. They allow for
separate version control and can be particularly useful when integrating
larger, well-maintained codebases into a project. Here are some scenarios
where using Git submodules is recommended:

1. **Maintainability**: Incorporating external code as submodules helps
    to keep track of changes in the upstream repository while keeping
    the parent project repository lean and focused
1. **Versioning**: When an external project receives updates, a submodule
    makes it easy to pull in the latest changes, ensuring the parent
    project stays up-to-date without duplicating code
1. **Collaboration**: Submodules facilitate collaboration between the original
    project maintainers and the parent project. Our team can contribute back
    to the external project, if needed, and also benefit from their
    enhancements
1. **Isolation**: By keeping external code in a separate repository, we can
    manage permissions, branches, and releases independently, reducing
    potential conflicts and streamlining our development process

### Direct Copying for Small Components

There are instances where copying one or two source files might be more
appropriate. Consider the following scenarios:

1. **Small Components**: If the external code consists of only one or a few
    files, copying might be simpler and more practical, especially when
    integrating a very small piece of functionality
1. **Customization**: When the external code needs significant modification to
    fit our project's requirements, copying the code might provide more
    flexibility
1. **External Code Inaccessibility**: In cases where accessing the external
    repository is not feasible, such as a private repository or an external
    codebase that is no longer maintained, copying may be the only viable option

In general, if the external codebase is substantial, actively maintained, and
requires ongoing synchronization, using Git submodules is recommended. For
small, isolated components or situations where copying is more suitable,
exercise your judgment while ensuring code quality and adherence to our coding
standards.

Before incorporating external code, please discuss your intentions with the
project maintainers and adhere to any specific guidelines they may provide.

## Attribution
This guide is based on the **contributing-gen**. [Make your own](https://github.com/bttger/contributing-gen)!
