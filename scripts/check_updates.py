#!/usr/bin/python3

import re
import sys
import requests


def _request_json_for_key(url, key):
    try:
        res = requests.get(url).json()
        if isinstance(res, list):
            return [i[key] for i in res]
        else:
            return res[key]
    except Exception:
        return None


def get_github_version(repo_name):
    head_url = f"https://api.github.com/repos/{repo_name}/releases/latest"
    ver = _request_json_for_key(head_url, 'tag_name')
    if re.match(r"^v[\d.-_]+$", ver):
        ver = ver[1:]
    return ver


def get_docker_versions(repo_name):
    head_url = f"https://index.docker.io/v1/repositories/{repo_name}/tags"
    return _request_json_for_key(head_url, 'name')


def main(github_repo, docker_repo):
    github_ver = get_github_version(github_repo)
    docker_vers = get_docker_versions(docker_repo)
    if docker_vers and github_ver in docker_vers:
        print("false")
    else:
        print(github_ver)


if __name__ == "__main__":
    args = sys.argv[1:]
    main(args[0], args[1])
