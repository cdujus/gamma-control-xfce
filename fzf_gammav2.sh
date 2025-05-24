#!/bin/bash

# Obtener la salida actual de pantalla
SALIDA=$(xrandr | grep " connected" | cut -d" " -f1)

# Opciones de gamma con emojis
OPTIONS=(
  "0.5" "🌑 Muy Oscuro"
  "0.7" "🌘 Oscuro"
  "0.9" "🥹 Semi-Oscuro"
  "1.0" "🙂 Normal"
  "1.2" "🤨 Claro"
  "1.5" "😐 Más Claro"
  "2.0" "🌻 Brillante"
  "2.5" "☀️ Muy Brillante"
  "3.0" "😭 Máximo Brillo"
  "❌ Salir" "🚪 Salir del script"
)

# Mostrar selector con color personalizado y borde
SELECCION=$(printf "%s\t%s\n" "${OPTIONS[@]}" | \
  column -t -s $'\t' | \
  fzf \
    --prompt="🌈 Gamma > " \
    --header="Selecciona un nivel de brillo (pulsa 'q' para salir)" \
    --bind "q:abort" \
    --height=100% \
    --layout=reverse \
    --border \
    --color=fg:#ffccff,bg:#1a1a1a,hl:#ff66cc,header:#ff66cc,info:#ff99cc,pointer:#ff66cc,marker:#ff66cc,prompt:#ff99cc
)

# Si cancela o elige salir
if [[ -z "$SELECCION" || "$SELECCION" =~ "❌" ]]; then
  echo -e "\n🚪 Saliste sin aplicar cambios."
  exit 0
fi

# Extraer solo el valor numérico de gamma
GAMMA=$(echo "$SELECCION" | awk '{print $1}')

# Aplicar gamma con xrandr
if xrandr --output "$SALIDA" --gamma "$GAMMA:$GAMMA:$GAMMA" 2>/dev/null; then
  echo -e "\n✅ Gamma ajustado a $GAMMA"
else
  echo -e "\n❌ Error al aplicar gamma: $GAMMA"
fi

