**# Ansible Project for Package Installation and User Creation**

**## Overview**

This Ansible project automates the installation of packages on Ubuntu and Red Hat Linux distributions. It leverages roles, tasks files, and a playbook to ensure consistent and repeatable configuration across multiple hosts. It also creates a dedicated Ansible user with sudo privileges for secure execution of tasks.

**## Requirements**

- Ansible installed on the control machine
- Inventory file listing target hosts (see `inventory/hosts`)
- SSH access to target hosts with passwordless authentication

**## Project Structure**

```
├── README.md                # This file
├── inventory                # Inventory file(s)
├── playbook.yaml            # Main playbook
├── roles/
│   └── package_installer/   # Role for package installation
│       ├── tasks/           # Tasks for the role
│       ├── handlers/        # Handlers for the role
│       ├── vars/            # Variables for the role
│       ├── defaults/        # Default values for variables
│       └── meta/            # Role metadata
└── ...                      # Other files or directories as needed
```

**## Roles**

- **package_installer:** Manages package installation on Ubuntu and Red Hat systems.

**## Playbook**

- **playbook.yaml:** Executes the tasks defined in the roles.

**## Usage**

1. **Update inventory file:** List target hosts in the `inventory/hosts` file.
2. **Review variables:** Adjust variables in `roles/package_installer/vars/main.yml` or `playbook.yaml` for package names and Ansible user details.
3. **Run playbook:** Execute the playbook using:

   ```bash
   ansible-playbook playbook.yaml
   ```

**## Additional Information**

- **Supported Distributions:** Ubuntu and Red Hat Linux
- **Package Installation:** Handled by the `package_installer` role
- **Ansible User Creation:** Configured in the playbook
- **Role Tasks:** See `roles/package_installer/tasks/main.yml` for details
- **Error Handling:** Implemented using Ansible's error handling mechanisms
- **Logging:** Utilizes Ansible's logging capabilities

**## Best Practices**

- **Test in a Non-Production Environment:** Always test playbooks in a staging environment before applying them to production systems.
- **Use Version Control:** Manage project changes using a version control system like Git.
- **Document Thoroughly:** Provide clear documentation for roles, tasks, and variables.
- **Follow Ansible Best Practices:** Adhere to Ansible guidelines for structure, organization, and security.
