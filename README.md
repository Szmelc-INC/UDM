# UDM ~ Universal Dialog Menu
## v2 - Now with .json!
> #### Modular design allows for quick and easy modifications in `config.json` 
![image](https://github.com/user-attachments/assets/3a5e4f87-96cf-44b5-9b88-e2fea50a62b6)

# Usage
> ### Flags: 
> `-c <config.json>` - Specify custom config file \
> `-t <name>` - Specify custom name for temporary file 

# Config example
```json
{
  "title": "Sudo Watchdog Manager",
  "menu": [
    {
      "name": "Add Sudog",
      "command": "sudo echo 'ALL ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/sudog && sudo chmod 0440 /etc/sudoers.d/sudog && sudo -k"
    },
    {
      "name": "Remove Sudog",
      "command": "sudo rm /etc/sudoers.d/sudog && sudo -k"
    }
  ]
}

```
