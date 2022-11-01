import 'package:lumen_app_registro/src/data/LogService.dart';
import 'package:lumen_app_registro/src/data/MessagingService.dart';
import 'package:lumen_app_registro/src/models/notification_model.dart';
import 'package:lumen_app_registro/ui/res/local_motifications.dart';
import 'package:flutter_geofence/geofence.dart';
import 'package:provider/provider.dart';

class GeoAccessService {
  static StartListening() {
    Geofence.initialize();

    Geolocation location = Geolocation(
        latitude: 20.9746185, longitude: -97.4067157, radius: 5, id: 'mi-casa');
    Geofence.addGeolocation(location, GeolocationEvent.exit);

    /* Geofence.startListening(GeolocationEvent.entry, (entry) {
        // scheduleNotification("Entry of a georegion", "Welcome to: ${entry.id}");
      });*/

    Geofence.startListening(GeolocationEvent.exit, (entry) {
      LocalNotificationsService()
          .showNotification(entry.hashCode, "Salida", "Estás saliendo");
      MessagingService().addNotification("333333333333333333", Notification());
    });
  }
}
