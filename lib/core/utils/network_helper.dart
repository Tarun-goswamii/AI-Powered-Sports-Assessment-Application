import 'dart:io';

class NetworkHelper {
  static String? _cachedNetworkIP;
  
  /// Get the network IP address for mobile connectivity
  static Future<String> getNetworkIP() async {
    if (_cachedNetworkIP != null) {
      return _cachedNetworkIP!;
    }
    
    try {
      // Try to get network interfaces
      final interfaces = await NetworkInterface.list(
        includeLoopback: false,
        type: InternetAddressType.IPv4,
      );
      
      for (final interface in interfaces) {
        // Look for Wi-Fi or Ethernet interfaces
        if (interface.name.toLowerCase().contains('wi-fi') ||
            interface.name.toLowerCase().contains('ethernet') ||
            interface.name.toLowerCase().contains('wlan')) {
          
          for (final address in interface.addresses) {
            final ip = address.address;
            // Check if it's a private network IP
            if (_isPrivateIP(ip)) {
              _cachedNetworkIP = ip;
              return ip;
            }
          }
        }
      }
      
      // Fallback: use first available private IP
      for (final interface in interfaces) {
        for (final address in interface.addresses) {
          final ip = address.address;
          if (_isPrivateIP(ip)) {
            _cachedNetworkIP = ip;
            return ip;
          }
        }
      }
      
      // Final fallback
      return 'localhost';
      
    } catch (e) {
      print('Network IP detection failed: $e');
      return 'localhost';
    }
  }
  
  /// Check if an IP address is in private network range
  static bool _isPrivateIP(String ip) {
    final parts = ip.split('.');
    if (parts.length != 4) return false;
    
    try {
      final first = int.parse(parts[0]);
      final second = int.parse(parts[1]);
      
      // Private IP ranges:
      // 10.0.0.0 - 10.255.255.255
      // 172.16.0.0 - 172.31.255.255  
      // 192.168.0.0 - 192.168.255.255
      return (first == 10) ||
             (first == 172 && second >= 16 && second <= 31) ||
             (first == 192 && second == 168);
    } catch (e) {
      return false;
    }
  }
  
  /// Get ML server URL for mobile devices
  static Future<String> getMobileMLServerUrl({int port = 5001}) async {
    final ip = await getNetworkIP();
    return 'http://$ip:$port';
  }
  
  /// Test connectivity to ML server
  static Future<bool> testMLServerConnectivity({int port = 5001}) async {
    try {
      final ip = await getNetworkIP();
      final url = 'http://$ip:$port/health';
      
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 5);
      
      final request = await client.getUrl(Uri.parse(url));
      final response = await request.close();
      
      final isHealthy = response.statusCode == 200;
      client.close();
      
      return isHealthy;
    } catch (e) {
      print('ML server connectivity test failed: $e');
      return false;
    }
  }
}