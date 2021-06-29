import json
import os
import os.path
import pytest

import latestimage


def _datafile(path: str) -> str:
    base = os.environ["TEST_SRCDIR"]
    return os.path.join(base, "__main__/tools/latestimage", path)


def test_getlabel():
    config = latestimage.Config("grafana", "grafana", "grafana", "latest", r"^[\d\.]+$")
    with open(_datafile("testdata/grafana_images.json"), "r") as inf:
        images = json.load(inf)
    assert "8.0.3" == latestimage.getlabel(images, config)

    config = latestimage.Config(
        "prom_alertmanager", "prom", "alertmanager", "latest", r"^v[\d\.]+$"
    )
    with open(_datafile("testdata/alertmanager_images.json"), "r") as inf:
        images = json.load(inf)
    assert "v0.22.2" == latestimage.getlabel(images, config)

    config = latestimage.Config(
        "synapse", "matrixdotorg", "synapse", None, r"^v[\d\.]+$"
    )
    with open(_datafile("testdata/synapse_images.json"), "r") as inf:
        images = json.load(inf)
    assert "v1.42.0" == latestimage.getlabel(images, config)


if __name__ == "__main__":
    raise SystemExit(pytest.main([__file__]))
