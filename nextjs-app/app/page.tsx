'use client'

import { useState } from 'react'

interface StepInfo {
  title: string
  content: string
}

const stepInfo: Record<number, StepInfo> = {
  1: {
    title: "Certificate Request Initiated",
    content: `When Caddy starts or detects a new domain configuration:
• Checks for existing valid certificate
• Identifies ACME CA endpoint: https://vault.primary-vault.svc.cluster.local:8200/v1/intermediate-ca/acme/directory
• Prepares certificate signing request (CSR)
• Initiates ACME protocol handshake`
  },
  2: {
    title: "ACME Challenge Process",
    content: `ACME client communicates with Vault PKI:
• Sends account registration to ACME endpoint
• Requests authorization for domain: caddy.hashibank.com
• Vault responds with challenge requirements
• Challenge type: HTTP-01 (domain validation via web)`
  },
  3: {
    title: "Domain Ownership Validation",
    content: `Vault validates domain control:
• Places challenge token at /.well-known/acme-challenge/
• Vault makes HTTP request to verify token
• Confirms applicant controls the domain
• Authorization granted for certificate issuance`
  },
  4: {
    title: "Certificate Signing & Issuance",
    content: `Vault PKI Engine processes request:
• Validates CSR against policy rules
• Signs certificate using intermediate CA
• Certificate includes: SAN, validity period, key usage
• Returns certificate chain to ACME client`
  },
  5: {
    title: "Automatic Certificate Deployment",
    content: `Caddy handles certificate installation:
• Receives certificate and private key
• Updates TLS configuration dynamically
• Begins serving HTTPS traffic immediately
• No manual intervention or restart required`
  },
  6: {
    title: "Automated Renewal Process",
    content: `Continuous certificate lifecycle management:
• Monitors certificate expiration (typically 30 days before)
• Automatically initiates renewal process
• Seamless certificate replacement
• Maintains zero-downtime operations`
  }
}

export default function Home() {
  const [activeStep, setActiveStep] = useState<number>(1)
  const [activePanel, setActivePanel] = useState<string>('')

  const showCertInfo = () => {
    setActivePanel(`🔗 Certificate Chain Information

Root CA: lab-root-ca
├── Intermediate CA: intermediate-ca  
    └── End Entity: caddy.hashibank.com

Certificate Details:
• Subject: CN=caddy.hashibank.com
• Issuer: intermediate-ca
• Signature Algorithm: RSA-SHA256
• Key Usage: Digital Signature, Key Encipherment
• Extended Key Usage: Server Authentication
• Validity: 90 days (auto-renewable)`)
  }

  const showVaultInfo = () => {
    setActivePanel(`🏛️ HashiCorp Vault PKI Configuration

PKI Mount Path: intermediate-ca/
ACME Endpoint: /v1/intermediate-ca/acme/directory
Cluster URLs: https://vault.primary-vault.svc.cluster.local:8200

Configuration:
• ACME enabled: true
• EAB Policy: not-required  
• Allowed issuers: ["*"]
• Default TTL: 90 days
• Max TTL: 1 year
• Role: dev-role

Security Features:
• Automatic certificate lifecycle management
• Policy-based certificate issuance
• Audit logging of all certificate operations
• Integration with Kubernetes secrets`)
  }

  const showACMEInfo = () => {
    setActivePanel(`⚙️ ACME Protocol Configuration

ACME Directory URL:
https://vault.primary-vault.svc.cluster.local:8200/v1/intermediate-ca/acme/directory

ACME Endpoints:
• New Account: /acme/new-account
• New Order: /acme/new-order  
• Authorization: /acme/authz/
• Challenge: /acme/challenge/
• Certificate: /acme/cert/

Challenge Types Supported:
• HTTP-01: Domain validation via web challenge
• DNS-01: Domain validation via DNS record

Client Configuration:
• Server: Caddy v2.x with ACME support
• Challenge Response: Automatic HTTP-01 handling
• Key Type: RSA 2048-bit or ECDSA P-256
• Renewal: 30 days before expiration`)
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-hashicorp-500 to-purple-600">
      <div className="container mx-auto px-4 py-8 max-w-6xl">
        {/* Header */}
        <div className="text-center text-white mb-12 py-12">
          <h1 className="text-5xl font-bold mb-4 drop-shadow-lg">
            🏦 HashiBank
          </h1>
          <p className="text-xl opacity-90">
            ACME Certificate Automation with HashiCorp Vault PKI
          </p>
        </div>

        {/* Certificate Status Card */}
        <div className="card p-8 mb-8">
          <div className="flex flex-col lg:flex-row items-start lg:items-center justify-between gap-6">
            <div>
              <h2 className="text-2xl font-bold text-gray-800 mb-2 flex items-center">
                🔒 Certificate Status
              </h2>
              <p className="text-gray-600">
                This server automatically obtains TLS certificates using ACME protocol
              </p>
            </div>
            <div className="flex items-center gap-3 bg-green-500 text-white px-6 py-3 rounded-full font-semibold">
              <div className="w-3 h-3 bg-white rounded-full animate-pulse-slow"></div>
              Certificate Active
            </div>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mt-6">
            {[
              { label: 'Domain', value: 'caddy.hashibank.com' },
              { label: 'Protocol', value: 'ACME v2' },
              { label: 'CA Authority', value: 'Vault PKI Engine' },
              { label: 'Auto-Renewal', value: 'Enabled' }
            ].map((item, index) => (
              <div key={index} className="bg-gray-50 p-4 rounded-lg border-l-4 border-hashicorp-500">
                <div className="font-semibold text-gray-800 mb-1">{item.label}</div>
                <div className="text-gray-600">{item.value}</div>
              </div>
            ))}
          </div>
        </div>

        {/* Process Flow */}
        <div className="card p-8 mb-8">
          <h2 className="text-2xl font-bold text-gray-800 mb-2">🔄 How ACME + Vault PKI Works</h2>
          <p className="text-gray-600 mb-6">Click on each step to learn more about the certificate automation process:</p>
          
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 mb-6">
            {Array.from({ length: 6 }, (_, i) => i + 1).map((step) => (
              <div
                key={step}
                className={`step-card ${activeStep === step ? 'active' : ''}`}
                onClick={() => setActiveStep(step)}
              >
                <div className={`inline-block w-8 h-8 rounded-full text-white font-bold leading-8 mb-3 ${
                  activeStep === step ? 'bg-green-500' : 'bg-hashicorp-500'
                }`}>
                  {step}
                </div>
                <h3 className="font-semibold text-gray-800 mb-2">
                  {step === 1 && 'Certificate Request'}
                  {step === 2 && 'ACME Challenge'}
                  {step === 3 && 'Domain Validation'}
                  {step === 4 && 'Certificate Issuance'}
                  {step === 5 && 'Auto-Deployment'}
                  {step === 6 && 'Renewal'}
                </h3>
                <p className="text-sm text-gray-600">
                  {step === 1 && 'Caddy identifies need for TLS certificate for domain'}
                  {step === 2 && 'ACME client initiates challenge with Vault PKI endpoint'}
                  {step === 3 && 'Vault validates domain ownership through HTTP/DNS challenge'}
                  {step === 4 && 'Vault PKI signs and issues certificate from intermediate CA'}
                  {step === 5 && 'Certificate automatically deployed and configured in Caddy'}
                  {step === 6 && 'Automatic renewal before expiration ensures zero downtime'}
                </p>
              </div>
            ))}
          </div>
          
          {/* Step Info Panel */}
          <div className="bg-gray-900 text-white rounded-lg p-6 font-mono text-sm">
            <h3 className="text-lg font-semibold mb-3">{stepInfo[activeStep].title}</h3>
            <pre className="whitespace-pre-wrap">{stepInfo[activeStep].content}</pre>
          </div>
        </div>

        {/* Technology Stack */}
        <div className="card p-8 mb-8">
          <h2 className="text-2xl font-bold text-gray-800 mb-6">🛠️ Technology Stack</h2>
          <div className="flex flex-wrap gap-3 justify-center">
            {[
              'HashiCorp Vault',
              'PKI Secret Engine',
              'ACME Protocol',
              'Next.js',
              'Tailwind CSS',
              'cert-manager',
              'Kubernetes',
              'Nginx Ingress'
            ].map((tech, index) => (
              <span
                key={index}
                className="bg-hashicorp-500 text-white px-4 py-2 rounded-full text-sm font-medium hover:bg-hashicorp-600 transition-colors duration-200"
              >
                {tech}
              </span>
            ))}
          </div>
        </div>

        {/* Interactive Section */}
        <div className="bg-gradient-to-r from-blue-50 to-cyan-50 border-2 border-dashed border-blue-300 rounded-xl p-8 text-center">
          <h2 className="text-2xl font-bold text-gray-800 mb-4">🔍 Interactive Certificate Inspector</h2>
          <p className="text-gray-600 mb-6">Explore the technical details of this certificate automation</p>
          
          <div className="flex flex-wrap gap-4 justify-center mb-6">
            <button onClick={showCertInfo} className="btn-primary">
              View Certificate Chain
            </button>
            <button onClick={showVaultInfo} className="btn-primary">
              Vault PKI Details
            </button>
            <button onClick={showACMEInfo} className="btn-primary">
              ACME Configuration
            </button>
          </div>
          
          {activePanel && (
            <div className="bg-gray-900 text-white rounded-lg p-6 font-mono text-sm text-left animate-pulse">
              <pre className="whitespace-pre-wrap">{activePanel}</pre>
            </div>
          )}
        </div>
      </div>
    </div>
  )
}
