from __future__ import print_function
import os
import sys
import time

from google.cloud import dns


def main(oldaddr, newaddr):
  client = dns.Client()
  zone = client.zone('bergmanhouse')
  rm_record = zone.resource_record_set('bergman.house.', 'A', 300, [oldaddr])
  add_record = zone.resource_record_set('bergman.house.', 'A', 300, [newaddr])
  changes = zone.changes()
  changes.delete_record_set(rm_record)
  changes.add_record_set(add_record)
  changes.create()

  max_tries = 5
  try_sleep = 60
  tries = 0
  while (tries < max_tries) and (changes.status != 'done'):
    time.sleep(try_sleep)
    tries += 1
    changes.reload()


if __name__ == '__main__':
  if len(sys.argv) != 3:
    print('usage: gcloud-dns-update OLDADDR NEWADDR', file=sys.stderr)
    sys.exit(os.EX_USAGE)
  main(sys.argv[1], sys.argv[2])
