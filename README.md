# dotfiles

This repo is intended to help setup a new Mac OS environment with preferred settings, software, and dotfiles
(like .gitconfig/etc). The defaults are my preferred settings and dotfiles, 
but you can customize settings to your liking.

## Usage

Clone this repository to your preferred install location. You will need to install the Mac OS command line tools.
If you try to clone this repository with git, you should be prompted to install them:

```bash
git clone https://github.com/brianporeilly/dotfiles
```

Before running anything else, check out the variable file: `./vars` is a symlink to the file
`./ansible-osx/host_vars/localhost` which contains the settings. You can leave the following alone
as the install script will prompt you for them:

* system_hostname: {HOSTNAME}
* user_fullname: {USER_FULLNAME}
* user_email: {USER_EMAIL}

When the settings you like are in place, run the install script which will install pre-requisites and then run the
ansible playbook:

```bash
./install.sh
```

### Requirements

This should be runnable on a fresh Mac OS install, the only requirement is the Command Line Developer tools
(which are auto-installed if you try running `git` or `python3`).

### Install issues?

If you are unable to get ansible installed for some reason (maybe python dependency errors), try running this 
fallback script to install the pre-reqs in a different manner:

```bash
./fallback_prereqs.sh
```

## Customization

Modify the `vars` (`ansible-osx/host_vars/localhost`) file, and/or dig into the roles in
`ansible-osx/roles` to see what happens here and make changes/customizations.

### Have extra dotfiles you want to include?

Place them (suffixed with `.j2`) in the `ansible-osx/roles/ansible-role-macos-setup/templates/` directory
and add them (without the `.j2` suffix) to the `dotfiles:` list in `vars`

For example, if I wanted to add a `.ideavimrc` dotfile to my home directory:

1) Create the file: `ansible-osx/roles/ansible-role-macos-setup/templates/.ideavimrc.j2`
2) Modify the `dotfiles` list in the `vars` file to include the desired filename (that corresponds to the template file)
```
dotfiles:
  - .gitconfig
  - .gitignore_global
  - .vimrc
  - .zshrc
  - .ideavimrc
```