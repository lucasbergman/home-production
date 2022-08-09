// -*- mode: hcl -*-

resource "google_dns_managed_zone" "bergmans" {
    name        = "bergmans"
    dns_name    = "bergmans.us."
    description = "bergmans.us"
    project     = var.gcloud_project
}

resource "google_dns_managed_zone" "bergmanhouse" {
    name        = "bergmanhouse"
    dns_name    = "bergman.house."
    description = "bergman.house"
    project     = var.gcloud_project
}

resource "google_dns_managed_zone" "boozyprofessor" {
    name        = "boozyprofessor"
    dns_name    = "boozyprofessor.com."
    description = "boozyprofessor.com"
    project     = var.gcloud_project
}

resource "google_dns_managed_zone" "maunder" {
    name        = "maunder"
    dns_name    = "maunder.chat."
    description = "maunder.chat"
    project     = var.gcloud_project
}

//
// bergmans.us records
//

resource "google_dns_record_set" "bergmans_mx" {
    managed_zone = google_dns_managed_zone.bergmans.name
    name = google_dns_managed_zone.bergmans.dns_name
    type = "MX"
    rrdatas = ["10 mail.bergmans.us."]
    ttl = 300
}

resource "google_dns_record_set" "bergmans_ns" {
    managed_zone = google_dns_managed_zone.bergmans.name
    name = google_dns_managed_zone.bergmans.dns_name
    type = "NS"
    rrdatas = [
        "ns-cloud-c1.googledomains.com.",
        "ns-cloud-c2.googledomains.com.",
        "ns-cloud-c3.googledomains.com.",
        "ns-cloud-c4.googledomains.com.",
    ]
    ttl = 21600
}

resource "google_dns_record_set" "bergmans_soa" {
    managed_zone = google_dns_managed_zone.bergmans.name
    name = google_dns_managed_zone.bergmans.dns_name
    type = "SOA"
    rrdatas = ["ns-cloud-c1.googledomains.com. cloud-dns-hostmaster.google.com. 2 21600 3600 259200 300"]
    ttl = 21600
}

resource "google_dns_record_set" "bergmans_spf" {
    managed_zone = google_dns_managed_zone.bergmans.name
    name = google_dns_managed_zone.bergmans.dns_name
    type = "SPF"
    rrdatas = ["\"v=spf1 mx include:mailgun.org include:_spf.google.com ~all\""]
    ttl = 3600
}

resource "google_dns_record_set" "bergmans_txt" {
    managed_zone = google_dns_managed_zone.bergmans.name
    name = google_dns_managed_zone.bergmans.dns_name
    type = "TXT"
    rrdatas = [
        "\"google-site-verification=DYzhaKYuvnbDIayaFdYl9m9OfzEZsMOWQggj0jujG38\"",
        "\"google-site-verification=euMnMSULQKzf2y2fKSF-3N3DpJaY8QjgNO_4ItxgG9M\"",
        "\"keybase-site-verification=oh8jpluTkVNxsrqj2A90qoKDhPY3SOCJjQJhkp6v9Tc\"",
    ]
    ttl = 3600
}

resource "google_dns_record_set" "bergmans_domainkey_txt" {
    managed_zone = google_dns_managed_zone.bergmans.name
    name = "smtp._domainkey.bergmans.us."
    type = "TXT"
    rrdatas = ["\"k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDCLfrlJUS2s2fzXKJDr4/VO3AqKkvlc9BsnFMTZep7ifTC3WpxYb38TGp1lUEGbVl+zIdep+0elcHzDz/6leMgCoFUoA4wyPEoM43bCkCoyghpIxtc3taNyRWGvzjjJ8WCU7EB1ZbIg44VzfZp+/YcUrJeUll/YJoFARmrROE1RwIDAQAB\""]
    ttl = 3600
}

resource "google_dns_record_set" "bergmans_domainkey_sendgrid1" {
    managed_zone = google_dns_managed_zone.bergmans.name
    name = "s1._domainkey.bergmans.us."
    type = "CNAME"
    rrdatas = ["s1.domainkey.u13710287.wl038.sendgrid.net."]
    ttl = 3600
}

resource "google_dns_record_set" "bergmans_domainkey_sendgrid2" {
    managed_zone = google_dns_managed_zone.bergmans.name
    name = "s2._domainkey.bergmans.us."
    type = "CNAME"
    rrdatas = ["s2.domainkey.u13710287.wl038.sendgrid.net."]
    ttl = 3600
}

resource "google_dns_record_set" "bergmans_domainkey_sendgrid3" {
    managed_zone = google_dns_managed_zone.bergmans.name
    name = "em2468.bergmans.us."
    type = "CNAME"
    rrdatas = ["u13710287.wl038.sendgrid.net."]
    ttl = 3600
}

resource "google_dns_record_set" "bergmans_cname_cmscal" {
    managed_zone = google_dns_managed_zone.bergmans.name
    name = "cmscal.bergmans.us."
    type = "CNAME"
    rrdatas = ["ghs.googlehosted.com."]
    ttl = 3600
}

resource "google_dns_record_set" "bergmans_a_git" {
    managed_zone = google_dns_managed_zone.bergmans.name
    name = "git.bergmans.us."
    type = "A"
    rrdatas = ["35.224.250.228"]
    ttl = 300
}

resource "google_dns_record_set" "bergmans_a_greywind" {
    managed_zone = google_dns_managed_zone.bergmans.name
    name = "greywind.bergmans.us."
    type = "A"
    rrdatas = ["45.79.142.74"]
    ttl = 300
}

resource "google_dns_record_set" "bergmans_a_hg" {
    managed_zone = google_dns_managed_zone.bergmans.name
    name = "hg.bergmans.us."
    type = "A"
    rrdatas = ["35.224.250.228"]
    ttl = 300
}

resource "google_dns_record_set" "bergmans_a_mail" {
    managed_zone = google_dns_managed_zone.bergmans.name
    name = "mail.bergmans.us."
    type = "A"
    rrdatas = ["45.79.142.74"]
    ttl = 300
}

resource "google_dns_record_set" "bergmans_a_mumble" {
    managed_zone = google_dns_managed_zone.bergmans.name
    name = "mumble.bergmans.us."
    type = "A"
    rrdatas = ["45.79.142.74"]
    ttl = 300
}

//
// bergman.house records
//

resource "google_dns_record_set" "bergmanhouse_mx" {
    managed_zone = google_dns_managed_zone.bergmanhouse.name
    name = google_dns_managed_zone.bergmanhouse.dns_name
    type = "MX"
    rrdatas = ["10 mail.bergman.house."]
    ttl = 1800
}

resource "google_dns_record_set" "bergmanhouse_a" {
    managed_zone = google_dns_managed_zone.bergmanhouse.name
    name = google_dns_managed_zone.bergmanhouse.dns_name
    type = "A"
    rrdatas = ["75.150.214.42"]
    ttl = 300
}

resource "google_dns_record_set" "bergmanhouse_ns" {
    managed_zone = google_dns_managed_zone.bergmanhouse.name
    name = google_dns_managed_zone.bergmanhouse.dns_name
    type = "NS"
    rrdatas = [
        "ns-cloud-b1.googledomains.com.",
        "ns-cloud-b2.googledomains.com.",
        "ns-cloud-b3.googledomains.com.",
        "ns-cloud-b4.googledomains.com.",
    ]
    ttl = 21600
}

resource "google_dns_record_set" "bergmanhouse_soa" {
    managed_zone = google_dns_managed_zone.bergmanhouse.name
    name = google_dns_managed_zone.bergmanhouse.dns_name
    type = "SOA"
    rrdatas = ["ns-cloud-b1.googledomains.com. cloud-dns-hostmaster.google.com. 1 21600 3600 259200 300"]
    ttl = 21600
}

resource "google_dns_record_set" "bergmanhouse_txt" {
    managed_zone = google_dns_managed_zone.bergmanhouse.name
    name = google_dns_managed_zone.bergmanhouse.dns_name
    type = "TXT"
    rrdatas = [
        "\"v=spf1 mx include:_spf.google.com ~all\"",
        "\"keybase-site-verification=yqOuTyKp0FzHtSIG_9dMEEzaibRJWvhqATJhZTOlYuU\"",
    ]
    ttl = 300
}

resource "google_dns_record_set" "bergmanhouse_matrix_srv" {
    managed_zone = google_dns_managed_zone.bergmanhouse.name
    name = "_matrix._tcp.bergman.house."
    type = "SRV"
    rrdatas = ["10 0 8448 matrix.bergman.house."]
    ttl = 300
}

resource "google_dns_record_set" "bergmanhouse_blog_cname" {
    managed_zone = google_dns_managed_zone.bergmanhouse.name
    name = "blog.bergman.house."
    type = "CNAME"
    rrdatas = ["bergman.house."]
    ttl = 300
}

resource "google_dns_record_set" "bergmanhouse_deluge_cname" {
    managed_zone = google_dns_managed_zone.bergmanhouse.name
    name = "deluge.bergman.house."
    type = "CNAME"
    rrdatas = ["bergman.house."]
    ttl = 300
}

resource "google_dns_record_set" "bergmanhouse_grafana_cname" {
    managed_zone = google_dns_managed_zone.bergmanhouse.name
    name = "grafana.bergman.house."
    type = "CNAME"
    rrdatas = ["bergman.house."]
    ttl = 300
}

resource "google_dns_record_set" "bergmanhouse_hass_cname" {
    managed_zone = google_dns_managed_zone.bergmanhouse.name
    name = "hass.bergman.house."
    type = "CNAME"
    rrdatas = ["bergman.house."]
    ttl = 300
}

resource "google_dns_record_set" "bergmanhouse_hedwig_cname" {
    managed_zone = google_dns_managed_zone.bergmanhouse.name
    name = "hedwig.bergman.house."
    type = "CNAME"
    rrdatas = ["bergman.house."]
    ttl = 300
}

resource "google_dns_record_set" "bergmanhouse_mon_cname" {
    managed_zone = google_dns_managed_zone.bergmanhouse.name
    name = "mon.bergman.house."
    type = "CNAME"
    rrdatas = ["bergman.house."]
    ttl = 300
}

resource "google_dns_record_set" "bergmanhouse_moneydance_cname" {
    managed_zone = google_dns_managed_zone.bergmanhouse.name
    name = "moneydance.bergman.house."
    type = "CNAME"
    rrdatas = ["bergman.house."]
    ttl = 300
}

resource "google_dns_record_set" "bergmanhouse_plex_cname" {
    managed_zone = google_dns_managed_zone.bergmanhouse.name
    name = "plex.bergman.house."
    type = "CNAME"
    rrdatas = ["bergman.house."]
    ttl = 300
}

resource "google_dns_record_set" "bergmanhouse_unifi_cname" {
    managed_zone = google_dns_managed_zone.bergmanhouse.name
    name = "unifi.bergman.house."
    type = "CNAME"
    rrdatas = ["bergman.house."]
    ttl = 300
}

resource "google_dns_record_set" "bergmanhouse_mail" {
    managed_zone = google_dns_managed_zone.bergmanhouse.name
    name = "mail.bergman.house."
    type = "A"
    rrdatas = ["45.79.142.74"]
    ttl = 1800
}

resource "google_dns_record_set" "bergmanhouse_matrix_a" {
    managed_zone = google_dns_managed_zone.bergmanhouse.name
    name = "matrix.bergman.house."
    type = "A"
    rrdatas = ["75.150.214.42"]
    ttl = 300
}

//
// boozyprofessor.com records
//

resource "google_dns_record_set" "boozyprofessor_ns" {
    managed_zone = google_dns_managed_zone.boozyprofessor.name
    name = google_dns_managed_zone.boozyprofessor.dns_name
    type = "NS"
    rrdatas = [
        "ns-cloud-a1.googledomains.com.",
        "ns-cloud-a2.googledomains.com.",
        "ns-cloud-a3.googledomains.com.",
        "ns-cloud-a4.googledomains.com.",
    ]
    ttl = 21600
}

resource "google_dns_record_set" "boozyprofessor_soa" {
    managed_zone = google_dns_managed_zone.boozyprofessor.name
    name = google_dns_managed_zone.boozyprofessor.dns_name
    type = "SOA"
    rrdatas = ["ns-cloud-a1.googledomains.com. cloud-dns-hostmaster.google.com. 1 21600 3600 259200 300"]
    ttl = 21600
}

resource "google_dns_record_set" "boozyprofessor_mx" {
    managed_zone = google_dns_managed_zone.boozyprofessor.name
    name = google_dns_managed_zone.boozyprofessor.dns_name
    type = "MX"
    rrdatas = ["10 mail.boozyprofessor.com."]
    ttl = 1800
}

resource "google_dns_record_set" "boozyprofessor_mail" {
    managed_zone = google_dns_managed_zone.boozyprofessor.name
    name = "mail.boozyprofessor.com."
    type = "A"
    rrdatas = ["45.79.142.74"]
    ttl = 1800
}

//
// maunder.chat records
//

resource "google_dns_record_set" "maunder_ns" {
    managed_zone = google_dns_managed_zone.maunder.name
    name = google_dns_managed_zone.maunder.dns_name
    type = "NS"
    rrdatas = [
        "ns-cloud-c1.googledomains.com.",
        "ns-cloud-c2.googledomains.com.",
        "ns-cloud-c3.googledomains.com.",
        "ns-cloud-c4.googledomains.com.",
    ]
    ttl = 21600
}

resource "google_dns_record_set" "maunder_soa" {
    managed_zone = google_dns_managed_zone.maunder.name
    name = google_dns_managed_zone.maunder.dns_name
    type = "SOA"
    rrdatas = ["ns-cloud-c1.googledomains.com. cloud-dns-hostmaster.google.com. 1 21600 3600 259200 300"]
    ttl = 21600
}

resource "google_dns_record_set" "maunder_mx" {
    managed_zone = google_dns_managed_zone.maunder.name
    name = google_dns_managed_zone.maunder.dns_name
    type = "MX"
    rrdatas = ["10 mail.maunder.chat."]
    ttl = 1800
}

resource "google_dns_record_set" "maunder_mail" {
    managed_zone = google_dns_managed_zone.maunder.name
    name = "mail.maunder.chat."
    type = "A"
    rrdatas = ["45.79.142.74"]
    ttl = 1800
}
