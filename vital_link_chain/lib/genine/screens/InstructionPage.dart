import 'package:flutter/material.dart';

class InstructionsPage extends StatelessWidget {
  const InstructionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Blockchain Setup Guide',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.cyan.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet,
                      size: 48,
                      color: Colors.cyan,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'How to Get Your Blockchain Credentials',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Follow these steps to obtain your Ethereum address and private key',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // MetaMask Section
            _buildWalletSection(
              title: 'Option 1: MetaMask (Recommended)',
              subtitle: 'Browser extension and mobile app',
              icon: Icons.extension,
              color: Colors.orange,
              steps: [
                _buildStep(
                  number: '1',
                  title: 'Install MetaMask',
                  description: 'Visit metamask.io and install the browser extension or download the mobile app from your app store.',
                  icon: Icons.download,
                ),
                _buildStep(
                  number: '2',
                  title: 'Create a New Wallet',
                  description: 'Click "Create a Wallet" and follow the setup process. Make sure to save your seed phrase securely.',
                  icon: Icons.add_circle_outline,
                ),
                _buildStep(
                  number: '3',
                  title: 'Get Your Address',
                  description: 'Your Ethereum address is displayed at the top of MetaMask (starts with 0x). Click to copy it.',
                  icon: Icons.content_copy,
                ),
                _buildStep(
                  number: '4',
                  title: 'Export Private Key',
                  description: 'Go to Account Details → Export Private Key. Enter your password and copy the private key safely.',
                  icon: Icons.key,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Trust Wallet Section
            _buildWalletSection(
              title: 'Option 2: Trust Wallet',
              subtitle: 'Mobile cryptocurrency wallet',
              icon: Icons.phone_android,
              color: Colors.blue,
              steps: [
                _buildStep(
                  number: '1',
                  title: 'Download Trust Wallet',
                  description: 'Download Trust Wallet from the App Store (iOS) or Google Play Store (Android).',
                  icon: Icons.download,
                ),
                _buildStep(
                  number: '2',
                  title: 'Create New Wallet',
                  description: 'Open the app and select "Create a new wallet". Write down your recovery phrase securely.',
                  icon: Icons.add_circle_outline,
                ),
                _buildStep(
                  number: '3',
                  title: 'Find Your Address',
                  description: 'Tap on Ethereum, then tap "Receive" to see your wallet address. Copy the address.',
                  icon: Icons.content_copy,
                ),
                _buildStep(
                  number: '4',
                  title: 'Access Private Key',
                  description: 'Go to Settings → Wallets → [Your Wallet] → Show Recovery Phrase. Use this to derive your private key.',
                  icon: Icons.key,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Other Wallets Section
            _buildWalletSection(
              title: 'Option 3: Other Wallets',
              subtitle: 'Alternative wallet options',
              icon: Icons.wallet,
              color: Colors.green,
              steps: [
                _buildStep(
                  number: '1',
                  title: 'Coinbase Wallet',
                  description: 'Download from coinbase.com/wallet. Similar process to Trust Wallet for getting address and keys.',
                  icon: Icons.account_balance,
                ),
                _buildStep(
                  number: '2',
                  title: 'MyEtherWallet',
                  description: 'Visit myetherwallet.com to create a web-based wallet. Download the keystore file for your private key.',
                  icon: Icons.web,
                ),
                _buildStep(
                  number: '3',
                  title: 'Hardware Wallets',
                  description: 'Ledger or Trezor hardware wallets provide the highest security for storing your private keys.',
                  icon: Icons.security,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Security Warning
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.red,
                    size: 32,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Important Security Notice',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Never share your private key with anyone\n'
                    '• Store your private key and seed phrase securely offline\n'
                    '• Double-check wallet addresses before transactions\n'
                    '• Use reputable wallet providers only\n'
                    '• Enable two-factor authentication when available',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red.shade700,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Help Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.cyan.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.cyan.shade200),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.help_outline,
                    color: Colors.cyan,
                    size: 32,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Need Help?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyan,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'If you\'re having trouble setting up your wallet or finding your credentials, '
                    'contact our support team or refer to the wallet provider\'s documentation.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.cyan.shade700,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Add contact support functionality
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text(
                      'Contact Support',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletSection({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required List<Widget> steps,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: steps,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep({
    required String number,
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.cyan,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 20, color: Colors.grey.shade600),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}