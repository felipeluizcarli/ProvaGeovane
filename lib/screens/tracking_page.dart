import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class TrackingPage extends StatefulWidget {
  @override
  _TrackingPageState createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  String? _error;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Verifica se o GPS está ativo
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _error = 'Serviço de localização está desativado.');
        return;
      }

      // Verifica e solicita permissão
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _error = 'Permissão de localização negada.');
          return;
        }
      }

      // Permissão negada para sempre → abre configurações
      if (permission == LocationPermission.deniedForever) {
        setState(() => _error = 'Permissão permanentemente negada.');
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Permissão Necessária'),
            content: Text('O app precisa de permissão de localização. Deseja abrir as configurações?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await Geolocator.openAppSettings();
                },
                child: Text('Abrir Configurações'),
              ),
            ],
          ),
        );
        return;
      }

      // Obtém localização atual
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      print('📍 Localização: ${position.latitude}, ${position.longitude}');

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _error = null;
      });

      // Move a câmera se já estiver criada
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(_currentPosition!),
        );
      }
    } catch (e) {
      setState(() => _error = 'Erro ao obter localização: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rastreamento do Pedido')),
      body: _error != null
          ? Center(child: Text(_error!))
          : _currentPosition == null
              ? Center(child: CircularProgressIndicator())
              : Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _currentPosition!,
                        zoom: 16,
                      ),
                      onMapCreated: (controller) => _mapController = controller,
                      markers: {
                        Marker(
                          markerId: MarkerId('user_location'),
                          position: _currentPosition!,
                          infoWindow: InfoWindow(title: 'Você está aqui'),
                        ),
                      },
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: ElevatedButton.icon(
                        onPressed: _getCurrentLocation,
                        icon: Icon(Icons.my_location),
                        label: Text('Atualizar Localização'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
