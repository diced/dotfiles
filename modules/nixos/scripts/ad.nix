{ pkgs, ... }:

# small script to make updating images under arion better since i like controlling the pulling of images manually
{
  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "ad" ''
      if [ $# -eq 0 ]; then
        echo "Available Arion services:"
        systemctl list-units --all --no-legend --plain 'arion-*.service' | awk '{print $1}' | sed 's/^arion-//' | sed 's/\.service$//' | while read -r svc; do
          echo "  - $svc"
        done
        echo ""
        echo "Usage: ad <service> <pull|start|stop|restart>"
        exit 0
      fi

      SERVICE_NAME="arion-$1"
      ACTION="$2"

      if [ -z "$ACTION" ]; then
        echo "Error: Missing action."
        echo "Usage: ad <service> <pull|start|stop|restart>"
        exit 1
      fi

      case "$ACTION" in
        pull)
          echo "Looking up compose file for $SERVICE_NAME..."
          COMPOSE_FILE=$(systemctl status "$SERVICE_NAME" | grep -m 1 -o '/nix/store/[^ ]*docker-compose.yaml')

          if [ -z "$COMPOSE_FILE" ]; then
            echo "Error: Could not find docker-compose.yaml for $SERVICE_NAME."
            echo "Note: The service must be running for this script to extract the path."
            exit 1
          fi

          echo "Pulling images using $COMPOSE_FILE..."
          sudo docker compose -f "$COMPOSE_FILE" pull
          ;;
        start|stop|restart)
          echo "''${ACTION^}ing $SERVICE_NAME..."
          sudo systemctl "$ACTION" "$SERVICE_NAME"
          ;;
        *)
          echo "Error: Unknown action '$ACTION'."
          echo "Usage: ad <service> <pull|start|stop|restart>"
          exit 1
          ;;
      esac
    '')
  ];
}
