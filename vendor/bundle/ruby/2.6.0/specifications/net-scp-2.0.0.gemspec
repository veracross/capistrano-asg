# -*- encoding: utf-8 -*-
# stub: net-scp 2.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "net-scp".freeze
  s.version = "2.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jamis Buck".freeze, "Delano Mandelbaum".freeze, "Mikl\u00F3s Fazekas".freeze]
  s.cert_chain = ["-----BEGIN CERTIFICATE-----\nMIIDeDCCAmCgAwIBAgIBATANBgkqhkiG9w0BAQsFADBBMQ8wDQYDVQQDDAZuZXRz\nc2gxGTAXBgoJkiaJk/IsZAEZFglzb2x1dGlvdXMxEzARBgoJkiaJk/IsZAEZFgNj\nb20wHhcNMTgwNjA0MTA0OTQwWhcNMTkwNjA0MTA0OTQwWjBBMQ8wDQYDVQQDDAZu\nZXRzc2gxGTAXBgoJkiaJk/IsZAEZFglzb2x1dGlvdXMxEzARBgoJkiaJk/IsZAEZ\nFgNjb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDGJ4TbZ9H+qZ08\npQfJhPJTHaDCyQvCsKTFrL5O9z3tllQ7B/zksMMM+qFBpNYu9HCcg4yBATacE/PB\nqVVyUrpr6lbH/XwoN5ljXm+bdCfmnjZvTCL2FTE6o+bcnaF0IsJyC0Q2B1fbWdXN\n6Off1ZWoUk6We2BIM1bn6QJLxBpGyYhvOPXsYoqSuzDf2SJDDsWFZ8kV5ON13Ohm\nJbBzn0oD8HF8FuYOewwsC0C1q4w7E5GtvHcQ5juweS7+RKsyDcVcVrLuNzoGRttS\nKP4yMn+TzaXijyjRg7gECfJr3TGASaA4bQsILFGG5dAWcwO4OMrZedR7SHj/o0Kf\n3gL7P0axAgMBAAGjezB5MAkGA1UdEwQCMAAwCwYDVR0PBAQDAgSwMB0GA1UdDgQW\nBBQF8qLA7Z4zg0SJGtUbv3eoQ8tjIzAfBgNVHREEGDAWgRRuZXRzc2hAc29sdXRp\nb3VzLmNvbTAfBgNVHRIEGDAWgRRuZXRzc2hAc29sdXRpb3VzLmNvbTANBgkqhkiG\n9w0BAQsFAAOCAQEAXnNaYXWVr/sCsfZdza+yBBOobYPgjOgDRfqNO2YX8RFEyDNB\nAxBCQIF4OeUaoMbTQTVh24MwaDHpDTgqBAEfSs9h41lZewQaw4QUGJ6yxNVzO194\n2vYohv9vHpodBukIpUFGk40vQq8nOq2MzVyCb911wnt5d0ZQg+UJf5tdMYvRvATa\nF/dkTaqhq3wq/JJRghq8fJUqWN5aBtMQb/61z5J3mKAUJsUN2/VdDph2fRPDpECa\nuWREKzWwXbaB96/ZyzoyP7FsQBLgdDL++g2nF0neCENc5Wj5IlQZiH0a2+X3jAgm\n7UnoE3CP9Tk5GHVUina5gPyzl0VI4s4pYCPehQ==\n-----END CERTIFICATE-----\n".freeze]
  s.date = "2019-03-20"
  s.description = "A pure Ruby implementation of the SCP client protocol".freeze
  s.email = ["net-ssh@solutious.com".freeze]
  s.extra_rdoc_files = ["LICENSE.txt".freeze, "README.rdoc".freeze]
  s.files = ["LICENSE.txt".freeze, "README.rdoc".freeze]
  s.homepage = "https://github.com/net-ssh/net-scp".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.0.3".freeze
  s.summary = "A pure Ruby implementation of the SCP client protocol.".freeze

  s.installed_by_version = "3.0.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<net-ssh>.freeze, [">= 2.6.5", "< 6.0.0"])
      s.add_development_dependency(%q<test-unit>.freeze, [">= 0"])
      s.add_development_dependency(%q<mocha>.freeze, [">= 0"])
    else
      s.add_dependency(%q<net-ssh>.freeze, [">= 2.6.5", "< 6.0.0"])
      s.add_dependency(%q<test-unit>.freeze, [">= 0"])
      s.add_dependency(%q<mocha>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<net-ssh>.freeze, [">= 2.6.5", "< 6.0.0"])
    s.add_dependency(%q<test-unit>.freeze, [">= 0"])
    s.add_dependency(%q<mocha>.freeze, [">= 0"])
  end
end
