# SemaFor Installation Checklist

> **OS:** Ubuntu 22
> **Software Installation Process:** Git clone of installation script repository. Each step employs a separate script (requires basic kubectl and Linux admin experience).

---

## 1. 01_install — OS Configuration
- [ ] `00_update-sudoers.sh` — Configures the OS so that you don't need to enter your password when using sudo.
- [ ] `01_install-packages.sh` — Installs Linux utilities and services.
- [ ] `02_git-clone-http.sh` — Clones additional repos that contain SemaFor scripts for troubleshooting and SemaFor services helm charts.
- [ ] `03_create-ramdisk.sh` — Creates a RAM Disk to store data displayed in the conky overlay on the desktop.
- [ ] `04_stop-updates.sh` — Prevents OS packages from being updated. Reduces risk when the kernel is updated and requires an update to the GPU drivers.
- [ ] `05_configure-static-network.sh` — Configures Kubernetes to run on a static network (10.10.10.10) so the installation can run disconnected.
- [ ] `06_fix-route.sh` — If a default route doesn't exist, one is created that defaults to the static network (10.10.10.0/21). Required by Kubernetes when disconnected.
- [ ] `07_add-semafor-local.sh` — Adds an entry in /etc/hosts to define semafor.local as 10.10.10.10.
- [ ] `08_reboot.sh` — Reboot the computer.

## 2. 02_kubernetes-containerd — Kubernetes Installation
- [ ] `01_disable-swap.sh` — Disables swap. Required to be turned off to run Kubernetes.
- [ ] `02_kernel-modules.sh` — Applies recommended kernel modifications to run Kubernetes.
- [ ] `03_install-containerd.sh` — Installs and starts containerd.
- [ ] `04_setup-kubernetes.sh` — Setup keyrings for Kubernetes.
- [ ] `05_install-kubernetes.sh` — Install Kubernetes. Also prevents Kubernetes from being updated.
- [ ] `06_init-kubernetes-static.sh` — Initializes Kubernetes on the static network (10.10.10.10).
- [ ] `07_kubeadm-watch-status.sh` — Run in a separate terminal to watch the status of Kubernetes as other scripts are running.
- [ ] `08_install-flannel.sh` — Installs Flannel.
- [ ] `09_fix-coredns-configmap.sh` — Corrects coredns configmap to not use /etc/resolv to resolve domain names.
- [ ] `10_untaint-node.sh` — Untaints the master node so other pods can be scheduled on the node.
- [ ] `11_install-nvidia-toolkit.sh` — Installs NVIDIA Toolkit.
- [ ] `12_config-nvidia-toolkit.sh` — Configures NVIDIA Toolkit.
- [ ] `13_install-gpu-operator.sh` — Installs the GPU operator.
- [ ] `14_test-nvidia.sh` — Tests if Kubernetes can run a pod and can see the NVIDIA GPU.
- [ ] `15_create-namespace.sh` — Creates the semafor namespace.
- [ ] `16_delete-completed-pod.sh` — Deletes completed pod.
- [ ] `17_set-endpoints.sh` — Sets the Kubernetes endpoints.

## 3. 03_prometheus — CRDs
- [ ] `01_install-prometheus-stack-CRDs.sh` — Installs the Prometheus pods to create the CRDs. Required for SemaFor to run.
- [ ] `02_uninstall-prometheus-stack.sh` — Uninstalls Prometheus (not required on a single node installation).

## 4. 04_nfs — Storage
- [ ] `01_configure-nfs.sh` — Installs and configures an NFS share on the single node installation.
- [ ] `02_install-nfs-provisioner.sh` — Installs the NFS Provisioner so Kubernetes can make use of the NFS share.

## 5. 05_desktop — Icons
- [ ] `install.sh` — Copies icons to the desktop to use SemaFor.
- [ ] **Manual Step:** Look for icons on the desktop with a red X. Right-click and select "Allow Launching".

## 6. 06_boot — Custom Boot Script
- [ ] `create-custom-boot.sh` — Creates a process on boot to bring SemaFor back online after shutting down.

## 7. 07_registry — Docker Registry (Twuni)
- [ ] `01_create-twuni-namespace.sh` — Creates a twuni namespace.
- [ ] `02_apply-pvc.sh` — Creates persistent volume claims needed by SemaFor.
- [ ] `03_add-twuni.sh` — Configures apt to be able to install the twuni repository.
- [ ] `04_install-twuni.sh` — Installs twuni, a docker registry running in Kubernetes. Stores analytic and SemaFor system images for recovery.
- [ ] `05_modify-containerd-config.sh` — Modify containerd configuration to use the NVIDIA GPUs.
- [ ] `06_install-hosts-service.sh` — Creates a systemd service that runs on boot and updates the twuni IP address in /etc/hosts.

## 8. 08_docker-ce — Docker Runtime
- [ ] `01_setup-docker-ce.sh` — Sets up Docker CE.
- [ ] `02_install-docker-ce.sh` — Installs Docker CE.
- [ ] `03_test-docker-ce.sh` — Tests Docker CE to make sure it can run a docker image.
- [ ] `04_test-nvidia.sh` — Test NVIDIA in Docker CE to make sure docker can see the NVIDIA GPUs.
- [ ] `05_docker-group.sh` — Adds semafor to docker group.

## 9. 09_transfer-images — Image Management
- [ ] `01_semafor-images.sh` — Reminder to run semafor first before running the next set of scripts.
- [ ] `02_export-kubernetes-images.sh` — Exports containerd images to a tar file for backup.
- [ ] `03_copy-docker-images-to-docker-registry.sh` — Copies the docker images to the twuni docker registry.
- [ ] `04_update-containerd-config.sh` — Update containerd configuration to redirect a set of URLs to the twuni docker-registry.
