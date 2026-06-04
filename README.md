# Voadores anônimos

## Um pequeno simulador para grandes voadores
<img
  src="https://github.com/user-attachments/assets/9b32caeb-1552-4f76-9e2b-5db784464052"
  width="200"
  align="left"
/> Voadores anônimos é meu primeiro projeto no Godot. Se trata de um menu principal, uma montanha com pistas de voo e mais importantemente: um avião, que possui rodas e é manuseável!

O modelo de voo é indubitavelmente simples, porém divertido. Ele simula decentemente alguns fenômenos do voo, como o comportamento de stall e arfagem para virar, por exemplo, mas é também arcade o suficiente para se esperar de um clone do GTA da deep web todo carcomido.
<br clear = "left"/>

https://github.com/user-attachments/assets/1d68c5d8-748d-422e-acfe-122cf284801a



## Detalhes técnicos
O projeto inteiro foi feito em Godot e usa integralmente a GDScript. todas as scripts se encontram no root do repo (pretendo no entanto movê-las para seu próprio arquivo). Como esse foi meu primeiro projeto o código acabou ficando bem bagunçado.

As scripts:
  - menu.gd: simplesmente uma script para controlar o menu.
  - node3d.gd: algo que eu estive tratando como main até então. Encompassa as partes da lógica de entrar no avião e controlá-lo, além também do controle das diferentes câmeras.
  - plane.gd: controla a física do avião. Calcula alguns vetores importantes na aviação baseados em algumas variáveis do avião
  - plane.gd: controla a física do jogador. Controlador clássico de primeira pessoa. Não tente escalar a montanha, suas pernas são muito fracas nesse jogo.

## Seria legal
Adicionar uma cidade. Esses dias eu fiz o download de manhattan com uma quantidade baixíssima de polígonos, mas deve ser o suficiente para dar a ilusão de voar por cima de uma cidade em altas altitudes.

Adicionar nuvens. Até então a sensação de velocidade nesse jogo é basicamente nula! Com nuvens isso poderia mudar.

Implementar modelo de voo mais realista. Mesmo que até agora o modelo de voo tenha sido satisfatório, eu gostaria de experimentar mais com a física por trás dos aviões. Não confie na minha implementação como um modelo de voo realista!!!

Fazer montanhas procedurais infinitas realistas e bacanas.

Dar um motivo para o nome do jogo. Até então um nome mais apropriado seria "voador".

## Comentários finais
Usem Godot. Recomendo.

