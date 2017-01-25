Existing AD-user has primarysmtpaddress (user@domain.com)

Script will:
- Grab "user" from user@domain.com
- Add user@sub.domain.com to ext6
- Add random (8-digit) password to ext4

It also checks if ext6 or/and ext4 has values.
Don't ask me why I had to develop this... blurgh.