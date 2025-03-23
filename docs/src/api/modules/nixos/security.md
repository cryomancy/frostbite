# Kosei Security Configuration

This document explains the different configuration
options for securing your Kosei system.
It covers various **security levels**, **network locations**,
**use cases**, and **lockdown states** that can be applied to
ensure the system behaves securely and according to your needs.

## Table of Contents

- [Security Levels](#security-levels)
- [Network Locations](#network-locations)
- [Use Cases](#use-cases)
- [Lockdown States](#lockdown-states)

---

## Security Levels

The **security level** determines the general security posture of the system.
Based on this setting, the system can either be locked down to restrict access
or configured to allow more flexibility.

### Available Levels

- **`standard`**: A balanced security posture with common security practices.
  This is the default setting that provides
  good protection without being too restrictive.

- **`moderate`**: A more hardened configuration with additional
  security measures to reduce risk, but without being overly restrictive.

- **`restricted`**: A stricter security configuration, with more
  services locked down and tighter control over
  the system to minimize attack surface.

- **`strict`**: The highest level of security, with maximum restrictions
  in place to protect the system against the most severe threats.

**Example:**

```nix
kosei.security.settings.level = "moderate";
```

---

## Network Locations

The **location** setting describes where the system is located in the network,
influencing how exposed it is to external networks.
It helps define the appropriate security measures based on whether the system
is inside a secure network or exposed to the internet.

### Available Locations

- **`local`**: The system is part of an internal, secure network
  (e.g., within a home or private network). No special exposure to the internet.

- **`dmz`**: The system is exposed to the outside world but is isolated
  from internal networks. Common for hosting public-facing services (e.g., web servers).

- **`external`**: The system is located directly on the public internet and may
  need additional security measures to protect it from external threats.

- **`cloud`**: The system is hosted in a cloud environment
  (e.g., AWS, Azure, Google Cloud).
  Cloud environments often require specific security measures tailored to shared infrastructure.

- **`vps`**: The system is hosted on a Virtual Private Server (VPS).
  VPS providers may have different security assumptions, requiring extra vigilance.

- **`remote`**: This can refer to systems located remotely,
  whether hosted in a data center, a remote office, or other external locations.

**Example:**

```nix
location = "dmz";
```

---

## Use Cases

The **use case** setting allows you to define the role of the system,
which can affect the security settings and configurations you need to apply.

### Available Use Cases

- **`server`**: The system acts as a server, providing services to other machines
  (e.g., web server, database server).
  Requires a hardened configuration with an emphasis on security.

- **`workstation`**: A typical desktop or workstation setup
  for development or personal use. It may require fewer security
  restrictions than a server, but still needs
  protections against common threats.

- **`laptop`**: A portable system that may need additional security
  measures for protecting data, particularly against theft or loss.

- **`vm`**: A virtual machine that may have different security
  needs compared to physical machines,
  depending on the hypervisor and virtualization configuration.

**Example:**

```nix
useCase = "server";
```

---

## Lockdown States

The **lockdown state** defines whether the system is in a restricted mode
or a more open state. A lockdown state may limit access to certain features
or restrict the ability to make system changes.

### Available Lockdown States

- **`lockdown`**: The system is in a restricted state with certain actions
  and services disabled to reduce attack surfaces. This mode limits
  the flexibility of the system, typically to ensure higher security.

- **`unrestricted`** (or `free`): The system is in an open state
  with no lockdown restrictions. This allows full functionality,
  but the security risks are higher, and more care should be taken
  to secure the system through other means.

**Example:**

```nix
lockdownState = "unrestricted";
```

---
