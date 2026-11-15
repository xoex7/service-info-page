# Step 9 – Release v1.0.0 and deploy it to the VM

## A. Create the release (on GitHub, by any member after main is green)

```bash
git checkout main && git pull
git tag -a v1.0.0 -m "Release 1.0.0 - first working service page"
git push origin v1.0.0
```

The tag starts CI. When it is green you get:
- Image in GHCR: `ghcr.io/xoex7/service-info-page:1.0.0` and `:<short-sha>`
- Artifact `docker-image-1.0.0` containing the image archive and `build-info.txt`

On GitHub → Releases → Draft a new release → choose tag `v1.0.0` → paste the
contents of `build-info.txt` into the description → Publish.

One-time: repo owner opens **Packages → service-info-page → Package settings** and sets
visibility to **Public** (or links it to the repo) so the VM can pull without a token.

## B. Fill in the change record

Copy `records/change-records/CR-template.md` to `CR-001-release-v1.0.0.md`,
fill it in, and get a teammate's approval **before** deploying.

## C. Deploy on the VM (follow `docs/deployment-checklist.md`)

```bash
cd ~/service-info-page && git pull
./scripts/deploy.sh 1.0.0
```

Expected output ends with:
```
... HEALTHY http://127.0.0.1:8080/health -> {"status":"ok","version":"1.0.0"}
Deployed image ID: sha256:...
```

Check the image ID matches `image_id` in `build-info.txt` from the CI run.
Then open `http://127.0.0.1:8080/` and confirm the page shows version **1.0.0**.

## Offline option (no GHCR)

Download `docker-image-1.0.0` from the CI run page, copy it to the VM, then:

```bash
unzip docker-image-1.0.0.zip
gunzip -c image-<sha>.tar.gz | docker load
docker tag service-info-page:<sha> ghcr.io/xoex7/service-info-page:1.0.0
./scripts/deploy.sh 1.0.0
```
