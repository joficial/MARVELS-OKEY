altura=love.graphics.getHeight()
largura=love.graphics.getWidth()
local startmenu=true
local startinstrucoes=false
local startexit=false
local startcenario=false
local checaleftcima=false
local checaleftbaixo=false


local contiron=0


local contsuper=0

local pause=false
local ligado=true
local fimjogo=false

local ironcampeao=false
local supercampeao=false
local empate=false

placar={super=0,iron=0,gol=false}	

function love.load()
---------------------------carrega menu, cenario e musica-----------------------
	menu=love.graphics.newImage("img/menu.png")
	sweet=love.audio.newSource("som/sweet.mp3","stream")
	sweet : setLooping(true)
	love.audio.play(sweet)
	love.audio.setVolume(1)
---------------------------fim menu----------------------------

-------------inicializa o tempo do jogo------------------
	tempo=100
	-----------------------aqui carrego a musica do fim------------------------
	win=love.audio.newSource("som/win.mp3","stream")
	love.audio.setVolume(1)
	win : setLooping(false)
---------------------------aqui carrego a musica do gol------------------------------
	gol=love.audio.newSource("som/gol.mp3","stream")
	gol : setLooping(false)
	love.audio.setVolume(1)
-----------------------------musica do apito final------------------
	apito=love.audio.newSource("som/apito.mp3","stream")
	apito : setLooping(false)
	love.audio.setVolume(1)
-------------------------------aqui finalizo as musicas------------------------

-----------------aqui faz a fonte e a pintuacao------------------------
	fonte=love.graphics.newFont("font/ocr.ttf")
----------------------ainda do menu, aqui carrega play, exit e instrucoes------------
	play={}
		play.img=love.graphics.newImage("img/play.png")
		play.x=600
		play.y=225
		play.w=play.img:getWidth()
		play.h=play.img:getHeight()
		-----instrucoes botao-------
	instrucoesbutton={}
		instrucoesbutton.img=love.graphics.newImage("img/instrucoesbutton.png")
		instrucoesbutton.x=600
		instrucoesbutton.y=300
		instrucoesbutton.w=instrucoesbutton.img:getWidth()
		instrucoesbutton.h=instrucoesbutton.img:getHeight()
	----------exit-------------
	exit={}
		exit.img=love.graphics.newImage("img/exit.png")
		exit.x=600
		exit.y=375
		exit.w=exit.img:getWidth()
		exit.h=exit.img:getHeight()

	-----------fim-----------
	--------------carrega grafcos do game===============
	----------------------------carrega instrucoes--------------------
	instrucoes=love.graphics.newImage("img/instrucoes.png")
	----------------carrega cenario------------------
	cenario=love.graphics.newImage("img/cenario.png")
	-------------------carrega som do jogo e dados do audio----------------
	backy=love.audio.newSource("som/backy.mp3" , "stream")
	backy : setLooping(true)  -----reiniciar apos fim-----
	love.audio.setVolume( 1 )
	---------------------------------------------------------------
	love.physics.setMeter(62)
	mundo = love.physics.newWorld(0, 0, true)   ----------(gravidade em x, gravidade em y, se os corpos podem dormir)
	-----------carrega dados do personagem iron man-------------
	iron={}
		ironman=love.graphics.newImage("img/ironman.png")
		iron.x=100
		iron.y=300
		iron.r=0
		speediron=600
		speedironx=speediron* math.cos(math.pi/4) ----------correcao da parada da velocidade-----------
		speedirony=speediron* math.sin(math.pi/4) -----------rt------------
		iron.w=ironman:getWidth()           ----detecta a largura-------
		iron.h=ironman:getHeight() -----detecta a altura--------------
		---------------carrega biblioteca de fisica do super----------------
	     	iron.b = love.physics.newBody(mundo, iron.x , iron.y , "dynamic")  
	        iron.b:setMass(10)                                   
	        iron.s = love.physics.newCircleShape(46)                 
	        iron.f = love.physics.newFixture(iron.b, iron.s)         
	        iron.f:setRestitution(0.4)                            
	        iron.f:setUserData("Iron")  
   

--------------------------------------------------------------------------------------------------------------

	------------carrega dados do personagem superman-----------
	super={}
		superman=love.graphics.newImage("img/superman.png")
		super.x=800
		super.y=300
		super.r=0
		speedsuper=600
		speedsuperx=speedsuper* math.cos(math.pi/4) ----------correcao da parada da velocidade-----------
		speedsupery=speedsuper* math.sin(math.pi/4) -----------rt------------
		super.w=superman:getWidth()           ----detecta a largura-------
		super.h=superman:getHeight() -----detecta a altura--------------
		-----------------carrega biblioteca de fisia do super----------------
	     	super.b = love.physics.newBody(mundo, super.x , super.y , "dynamic")  
	        super.b:setMass(10)                                   
	        super.s = love.physics.newCircleShape(46)                 
	        super.f = love.physics.newFixture(super.b, super.s)         
	        super.f:setRestitution(0.4)                            
	        super.f:setUserData("Super")     


-----------------carrega biblioteca de fisica da bola e tals--------------
 
	ball={}
		bola=love.graphics.newImage("img/bola.png") ----------------carrega bola==------------
		ball.w=bola:getWidth() ------detecta a largura-----
		ball.h=bola:getHeight()-------detecta a altura-------
		ball.x=490 --- ball.w/2
		ball.y=400
		ball.r=0	
		speedball=600
			ball.b = love.physics.newBody(mundo, 490 , 400 , "dynamic")  --  x,y posicao, e dinamico para acertar outros objetos
		    ball.b:setMass(10)                                        -- deixa leve
		    ball.s = love.physics.newCircleShape(22.5)                  --raio
		    ball.f = love.physics.newFixture(ball.b, ball.s)          -- conecta
		    ball.f:setRestitution(0.4)                                --
		    ball.f:setUserData("Ball")	




    -----------------------------vamo ver(o que limite as bordas e tal-------
	 bordascima={}
	 	bordascima.b=love.physics.newBody(mundo, 500,14, "static") 
        bordascima.s = love.physics.newRectangleShape(1000,0)
        bordascima.f = love.physics.newFixture(bordascima.b, bordascima.s)
        bordascima.f:setUserData("bordascima")

    bordasbaixo={}
    	bordasbaixo.b=love.physics.newBody(mundo, 500 ,586, "static") 
        bordasbaixo.s = love.physics.newRectangleShape(1000,0)
        bordasbaixo.f = love.physics.newFixture(bordasbaixo.b, bordasbaixo.s)
        bordasbaixo.f:setUserData("bordasbaixo")
    ----------------------------divide o meio dos dois(NAO VOU USAR DIVISAO DO MEIO------------------
    --[[
     meio={}
    	
   	 	meio.b=love.physics.newBody(mundo, 500 ,300, "static") 
        meio.s = love.physics.newRectangleShape(1,600)
        meio.f = love.physics.newFixture(meio.b, meio.s)
        meio.f:setUserData("meio")
     --]]
	 ---------------------------------------------------------esquerda parte de cima--------------
	 leftcima={}
	 	leftcima.b = love.physics.newBody(mundo, 14 , 65, "static")       -------------USEI 14 COMO BORDAAAAAAAAA------
        leftcima.s = love.physics.newRectangleShape(0,80)
        leftcima.f = love.physics.newFixture(leftcima.b, leftcima.s)
        leftcima.f:setUserData("leftcima")
   ---------------------------------esquerda parte de baixo-------
  	 leftbaixo={}
	 	leftbaixo.b = love.physics.newBody(mundo, 14 ,542, "static") 
        leftbaixo.s = love.physics.newRectangleShape(0,80)
        leftbaixo.f = love.physics.newFixture(leftbaixo.b, leftbaixo.s)
        leftbaixo.f:setUserData("leftbaixo")
   ---------------------- direita parte de cima-------------------
   	rightcima={} 
	 	rightcima.b = love.physics.newBody(mundo, 986 , 55, "static") 
        rightcima.s = love.physics.newRectangleShape(0,97)
        rightcima.f = love.physics.newFixture(rightcima.b, rightcima.s)
        rightcima.f:setUserData("rightcima")
   -------------------------direita parte de baixo--------------------------
    rightbaixo={}
	 	rightbaixo.b =  love.physics.newBody(mundo, 986 ,545, "static") 
        rightbaixo.s = love.physics.newRectangleShape(0,85)
        rightbaixo.f = love.physics.newFixture(rightbaixo.b, rightbaixo.s)
        rightbaixo.f:setUserData("rightbaixo")

   ----------------------------essa parte faz apenas a bola atravessar os gols dos lados-------------------------------------
   --[[
   	if iron.b:getX() < 14 then	
   		checaleftcima=true
   	end
   	--]]
   	--[[
-------------------------------------------------------------------------AQUI COMECA A CARREGAR AS IMAGENS DOS NUMEROS------------------
	1=love.graphics.newImage("img/1.png")
	2=love.graphics.newImage("img/2.png")
	3=love.graphics.newImage("img/3.png")
	4=love.graphics.newImage("img/4.png")
	5=love.graphics.newImage("img/5.png")
	6=love.graphics.newImage("img/6.png")
	7=love.graphics.newImage("img/7.png")
	8=love.graphics.newImage("img/8.png")
----------------------------------------------------FIM------------------------------------------------
--]]
-------------------------carrega as imagens de empate e vitorias-----------------------
	ironcampeaoimg=love.graphics.newImage("img/ironcampeao.png")
	supercampeaoimg=love.graphics.newImage("img/ironcampeao.png")
	empateimg=love.graphics.newImage("img/empate.png")
---------------------------------------------------------------------------------------


end

function love.update(dt)
---------------------------------------------------------------------------
	if love.keyboard.isDown("r") and startcenario==true  then
	pause=true
	else
	---------------------------isso faz o tempo parar em um minuto e o jogo acabar tb---------------------

	if ligado==true and startcenario==true then
		tempo=tempo+1
	else 
		tempo=0
	end
	if 	tempo==6000 then
		ligado=false
		fimjogo=true
		win:play()
		backy:pause()
	end
	------------------atualizacao da fisica----------------
	mundo:update(dt)
	------------------------------------------------------------------------------
	----------------------aqui faz as imagens de vitori e empate
	--[[
	if fimjogo==true and player.iron>player.super then
		startcenario=false 
		ironcampeao=true
	elseif fimjogo==true and player.super>player.iron then
		startcenario=false
		supercampeao=true
	elseif fimjogo==true and player.super==player.iron then
		empate=true
		startcenario=false
	end
	--]]
------------------------------------------AQUI CARREGO O NUMERO DE GOLS----------------------------------------
---------------carrega o numero de gols do iron--------------------------
	if ball.b:getX() <= 12 and ball.b:getY()>=65 and ball.b:getY()<=542 then
		placar.super= placar.super + 1
    	resetaBola()
	end
---------------carrega o numero de gols do super--------------------------
	if ball.b:getX() >= 986 and ball.b:getY()>=55 and ball.b:getY()<=545 then
   		placar.iron = placar.iron + 1
		resetaBola()
	end
--------------------------------------------------------------------
--------------------------------- FIM LOAD GOLS----------------------------------------------------
----------------------funcao pra reiniciar a bola----------------------
function resetaBola()
	ball.b:setX(490)--coloca a bola na metade da largura e nessa distancia
	ball.b:setY(400)--coloca a bola na metade da altura da tela
	ball.b:setLinearVelocity(0,0)--zera o momento da bola
	gol:play()

end

-------------------aqui faz o teste da direita e esqyerda----------------------------------
	if iron.b:getX()<50  then  ----------esquerda
		resetaironleft()
	elseif iron.b:getX()>450 then ---------------meio----------------
		resetaironmeio()
	end
-----------------aqui faz para o super----------------
	if super.b:getX()>950 then  ------------direita
		resetasuperright()
	end
	if super.b:getX()<540 then ----------meio------
		resetasupermeio()
	end

-------------------------------------------------------AQ COMECA AS FUNCOES QUE REINICIAM OS PLAYERS--------------------------------
-----------------------ETAPA1: RESETA NA ESQUERDA---------------------------------
function resetaironleft()
	iron.b:setX(50)--coloca a iron na metade da largura e nessa distancia
	iron.b:setY(iron.b:getY())--coloca a bola na metade da altura da tela
	iron.b:setLinearVelocity(0,0)--zera o momentum da bola
end 
------------------------ETAPA2: RESETA No meio-------------------------------
function resetaironmeio()
	iron.b:setX(450)--coloca a iron na metade da largura e nessa distancia
	iron.b:setY(iron.b:getY())--coloca a bola na metade da altura da tela
	iron.b:setLinearVelocity(0,0)--zera o momentum da bola
end 
-------------------------ETAPA 3: RESETA O SUPER NA DIREITA------------------------
function resetasuperright()
	super.b:setX(950)--coloca a iron na metade da largura e nessa distancia
	super.b:setY(super.b:getY())--coloca a bola na metade da altura da tela
	super.b:setLinearVelocity(0,0)--zera o momentum da bola
end 
------------------------ETAPA 3: RESETA O SUPER NO MEIO------------------------
function resetasupermeio()
	super.b:setX(540)--coloca a iron na metade da largura e nessa distancia
	super.b:setY(super.b:getY())--coloca a bola na metade da altura da tela
	super.b:setLinearVelocity(0,0)--zera o momentum da bola
end 

--------------------------------teste da fisica de apenas um-----------
--[[
	if checaleftcima==true then 
		leftcima={}
			leftcima.b =  love.physics.newBody(mundo, 986 ,545, "static") 
        	leftcima.s = love.physics.newRectangleShape(1,1000)
        	leftcima.f = love.physics.newFixture(leftcima.b, leftcima.s)
        	leftcima.f:setUserData("leftcima")
       end
--]]

--------- novo teste logo em seguida, dessa forma cada vez que ele vai pra tras o super espeial eh ativado----------------------------
	if iron.b:getX() < 55 then
		iron.b:applyForce(10000,0)
		elseif iron.b:getX() >445 then
			iron.b:applyForce(-10000,0)
	end
	-------------------agoa para o super--------------------
	if super.b:getX()>945  then 
		super.b:applyForce(-10000,0)
		elseif super.b:getX()<550 then
			super.b:applyForce(10000,0)
	end
-------------------------------------------------------------

 


	---------------------------pra nao deicar a bolinha meio que bugar-------------
	if ball.b:getY()<39 then        --------------- em cima-----------------
		ball.b:applyForce(0,700)
	end
	if ball.b:getY()>560 then        --------------- em cima-----------------
		ball.b:applyForce(0,-700)
	end


----------------------------------------------------------AQUI COMECA OS CODGOS QUE APLICAM FORCA E FAZEM MOVER----------------------------
--------------------------PARA O IRON------------------
	if  love.keyboard.isDown("w") and love.keyboard.isDown("a") and startcenario==true then
			iron.b:applyForce(-400,-400)
		elseif love.keyboard.isDown("a") and love.keyboard.isDown("s") and startcenario==true then
			iron.b:applyForce(-400,400)
		elseif love.keyboard.isDown("s") and love.keyboard.isDown("d") and startcenario==true then
			iron.b:applyForce(400,400)
		elseif love.keyboard.isDown("w") and love.keyboard.isDown("d") and startcenario==true then
			iron.b:applyForce(400,-400)		
		elseif love.keyboard.isDown("a") and startcenario==true then
			iron.b:applyForce(-400, 0)
		elseif love.keyboard.isDown("d") and startcenario==true then
			iron.b:applyForce(400, 0)
		elseif love.keyboard.isDown("w") and startcenario==true then
			iron.b:applyForce(0, -400)
		elseif love.keyboard.isDown("s") and startcenario==true then
			iron.b:applyForce(0, 400)
	end


	--[[
------------------------pra nao deixar passar das bordas PARA O IRONMAN---------					
	if iron.b:getX() < 0  then ------embaixo-----
		iron.b:getX(0)
	end
	if iron.x<0 then ----------em cima----------
		iron.x=0
	end
	if iron.y> altura - iron.h then   ---------altura, parte de baixo
		iron.y= altura - iron.h   
	end 
	if iron.x > largura - iron.w then    ------------largura parte do lado direito
		iron.x = largura - iron.w 
	end 
--]]








	-----------------------------PARA O SUPER--------------
	if  love.keyboard.isDown("up") and love.keyboard.isDown("left")and startcenario==true then
			super.b:applyForce(-400,-400)
		elseif love.keyboard.isDown("left") and love.keyboard.isDown("down") and startcenario==true then
			super.b:applyForce(-400,400)
		elseif love.keyboard.isDown("down") and love.keyboard.isDown("right") and startcenario==true then
			super.b:applyForce(400,400)
		elseif love.keyboard.isDown("up") and love.keyboard.isDown("right") and startcenario==true then
			super.b:applyForce(400,-400)		
		elseif love.keyboard.isDown("left") and startcenario==true then
			super.b:applyForce(-400, 0)
		elseif love.keyboard.isDown("right") and startcenario==true then
			super.b:applyForce(400, 0)
		elseif love.keyboard.isDown("up") and startcenario==true then
			super.b:applyForce(0, -400)
		elseif love.keyboard.isDown("down") and startcenario==true then
			super.b:applyForce(0, 400)
	end
-----------------pra nao sair da tela-------------------------

--------------------------------------------------------------AQUI NAO VAI SER NECESSARIO NO MOMENTO-----------------------
----------------- comandos do teclado com correcao para o IRONMAN imagem---------------
	--[[
	if love.keyboard.isDown("w") and love.keyboard.isDown("a") then
	iron.y=iron.y - speedirony*dt
	iron.x=iron.x - speedironx*dt
		elseif love.keyboard.isDown("a") and love.keyboard.isDown("s") then
			iron.y=iron.y + speedirony*dt
			iron.x=iron.x - speedironx*dt
			 elseif love.keyboard.isDown("s") and love.keyboard.isDown("d") then
				iron.y=iron.y + speedirony*dt
				iron.x=iron.x + speedironx*dt
					elseif love.keyboard.isDown("w") and love.keyboard.isDown("d") then
						iron.y=iron.y - speedirony*dt
						iron.x=iron.x + speedironx*dt
							elseif 	love.keyboard.isDown("w") then
								iron.y = iron.y - speediron * dt
								
									elseif love.keyboard.isDown("a") then
										iron.x= iron.x - speediron* dt
											elseif love.keyboard.isDown("s") then
												iron.y=iron.y+speediron*dt
													elseif love.keyboard.isDown("d") then
														iron.x=iron.x + speediron*dt										
	end]]--
	
	--[[------------------------pra nao deixar passar das bordas PARA O IRONMAN---------					
	if iron.y<0 then ------embaixo-----
		iron.y=0
	end
	if iron.x<0 then ----------em cima----------
		iron.x=0
	end
	if iron.y> altura - iron.h then   ---------altura, parte de baixo
		iron.y= altura - iron.h   
	end 
	if iron.x > largura - iron.w then    ------------largura parte do lado direito
		iron.x = largura - iron.w 
	end 
	--]]
	-----------------pra nao deixar passdar do meio e atingir o lado adversario--------------
	--[[
	if iron.x>500 - iron.w then
		iron.x=500-iron.w
	end
------------ pra ficar certinho nas superficies de cima baixp e etc-----------------
	if iron.x<10 then        -------lado esquerdo ---------
		iron.x=10
	end
	if iron.y<10 then ----------- em cima----
		iron.y=10
	end
	if iron.y>490 then -------lado direito n precisa,ENTAO ESSE DAQ DE BAIXO-----
		iron.y=490
	end

	------------------------------------------------------------------------------------------------

------------------------------------------comandos do teclado para SUPERMAN---------------------------

	if love.keyboard.isDown("up") and love.keyboard.isDown("left") then
	super.y=super.y - speedsupery*dt
	super.x=super.x - speedsuperx*dt
		elseif love.keyboard.isDown("left") and love.keyboard.isDown("down") then
			super.y=super.y + speedsupery*dt
			super.x=super.x - speedsuperx*dt
			 elseif love.keyboard.isDown("down") and love.keyboard.isDown("right") then
				super.y=super.y + speedsupery*dt
				super.x=super.x + speedsuperx*dt
					elseif love.keyboard.isDown("up") and love.keyboard.isDown("right") then
						super.y=super.y - speedsupery*dt
						super.x=super.x + speedsuperx*dt
							elseif 	love.keyboard.isDown("up") then
								super.y = super.y - speedsuper * dt
									elseif love.keyboard.isDown("left") then
										super.x= super.x - speedsuper* dt
											elseif love.keyboard.isDown("down") then
												super.y=super.y+speedsuper*dt
													elseif love.keyboard.isDown("right") then
														super.x=super.x + speedsuper*dt
	end

 ------------------------pra nao deixar passar das bordas PARA O SUPERMAN---------					
	if super.y<0 then ------embaixo-----
		super.y=0
	end
	if super.x<0 then ----------em cima----------
		super.x=0
	end
	if super.y> altura - super.h then   ---------altura, parte de baixo
		super.y= altura - super.h   
	end 
	if super.x > largura - super.w then    ------------largura parte do lado direito
		super.x = largura - super.w 
	end
	
	-----------------pra nao deixar passar do meio e atingir o lado adversario--------------
	if super.x < 496  then ----------do meio----------
		super.x = 496
	end
------------ pra ficar certinho nas superficies de cima baixp e etc-----------------
	if super.x>890 then        -------  lado direito--------
		super.x=890
	end
	if super.y<10 then -----------em cima do lado direito----
		super.y=10
	end
	
	if super.y>490 then ------------parte dde baixo----------
		super.y=490
	end
	--]]
	----------------------------------------------------------------FIM DO DESNECSSARIO-----------------------------------------
------------ caso nao queira utilizar som teclar "O" OU OUTROS AI-----------
	if love.keyboard.isDown("1") then         
		love.audio.setVolume("1")
	elseif love.keyboard.isDown("2") then
		love.audio.setVolume("0.5")
	elseif love.keyboard.isDown("0") then
		love.audio.setVolume("0")
	end

end
end
--------uma funcao pra facilitar o draw do menu------------
function drawmenu( )
		love.graphics.draw(menu, 0, 0)
		love.graphics.draw(play.img, play.x, play.y) 
		love.graphics.draw(instrucoesbutton.img,instrucoesbutton.x,instrucoesbutton.y)
		love.graphics.draw(exit.img, exit.x, exit.y) 
end
------------------draw instruc--------------------------
function drawinstrucoes( )
		love.graphics.draw(instrucoes,0,0)
end
function drawcenario()
		love.graphics.draw(cenario,0,0)
-------------desenha personagens----------------
		love.graphics.draw(ironman,iron.b:getX() - 50,iron.b:getY() - 50)
		love.graphics.circle("line", iron.b:getX(),iron.b:getY(), iron.s:getRadius() ,50, 30 )
			---------------------------------------------------
		love.graphics.draw(superman,super.b:getX() - 50 ,super.b:getY() - 50 )
		love.graphics.circle("line", super.b:getX(),super.b:getY(), super.s:getRadius(),50, 30)
		------------------------------
-------------desenha bola-----------
		love.graphics.draw(bola, ball.b:getX() - 39 , ball.b:getY() - 22)
		love.graphics.circle("line", ball.b:getX(),ball.b:getY(), ball.s:getRadius(), 22.5, 20)----------criacao do objeto de fisica---

--------- desneha borda de cima=---------------
		love.graphics.polygon("line", bordascima.b:getWorldPoints(bordascima.s:getPoints()))
------------------------desenha borda de baixo----------------
		love.graphics.polygon("line", bordasbaixo.b:getWorldPoints(bordasbaixo.s:getPoints()))

------------------desenha leftcima------

		love.graphics.polygon("line", leftcima.b:getWorldPoints(leftcima.s:getPoints()))

--------desenha left baicxo------------
		love.graphics.polygon("line", leftbaixo.b:getWorldPoints(leftbaixo.s:getPoints()))

--------desenha right cima----------------
		love.graphics.polygon("line", rightcima.b:getWorldPoints(rightcima.s:getPoints()))

-------desenha right baixo-------------
		love.graphics.polygon("line", rightbaixo.b:getWorldPoints(rightbaixo.s:getPoints()))
------------------ continuacao do teste---------------------------------
--[[
	if checaleftcima==true then
		love.graphics.polygon("line",leftcima.b:getWorldPoints(leftcima.s:getPoints()))
	end
	--]]

----------------------------------AQUI COMECO A DESENHR gols IRON-------------------
	if startcenario==true then
		
		love.graphics.setColor(0,0,0)
		love.graphics.print(placar.iron,480,30,0,2,3)
		love.graphics.setColor(255,255,255)
	end
	---------------------------------------------------------------------------
------------------------------AQUI DESENHO DO SUPER---------------------
	if startcenario==true then
		
		love.graphics.setColor(0,0,0)
		love.graphics.print(placar.super,480,530,0,2,3)
		love.graphics.setColor(255,255,255)
	end
	-------------------------------------------------------------------
	-------------------tempo do jogo---------------------
	if ligado==true and startcenario==true and startmenu==false then
		love.graphics.setFont(fonte)
		love.graphics.setColor( 0 , 0 , 0)			
		love.graphics.print( tempo, 450,330,0,2.5,2.5)
		love.graphics.setColor( 255 , 255 , 255)		
	end


end

function love.mousepressed(px,py,button)
	--------------------- comandos para o play---------------------
	if button==1 and px>=play.x and px < play.x + play.w and py >=play.y and py < play.y + play.h then
		startmenu=false
		startinstrucoes=false
		startcenario=true
		startexit=false
		backy : play()
		sweet : pause()
	end
	--------------para instrucoes-------------------
 	if button==1 and px>=instrucoesbutton.x and px < instrucoesbutton.x + instrucoesbutton.w and py >=instrucoesbutton.y and py < instrucoesbutton.y + instrucoesbutton.h then
		startmenu=false
		startcenario=false
		startinstrucoes=true
		startexit=false
		sweet:pause()
	end
	---------------para o exit--------------
	if button==1 and px>=exit.x and px < exit.x + exit.w and py >=exit.y and py < exit.y + exit.h then
		startmenu=false
		startexit=true
		startcenario=false
	end
end

function love.draw()
	if startmenu==true and startcenario==false then
		drawmenu()
		
		
	elseif startinstrucoes==true and startexit==false and startcenario==false then
		drawinstrucoes()
		

	elseif startexit==true  then
		love.event.quit() ----------funcao que da quit no jogo--------------

	elseif startcenario==true and startexit==false and startmenu==false and startinstrucoes==false then
		drawcenario()
		

	end
------------------se estiver na instrucao e quiser voltar ao menu-------------
	if startinstrucoes==true and love.keyboard.isDown("return") then
		startinstrucoes=false
		startmenu=true
		sweet:play()

	end
---------------------caso ele esteja no meio do jogo e queira voltar--------
--[[
	if startcenario==true and love.keyboard.isDown("m") then
		startmenu=false
		backy:pause()
		sweet:play()
		tempo:pause()
		fimjogo=false
	end
	-------------pra sair no meio do jogo---------------------
	--[[
	if startcenario==true and love.keyboard.isDown("return") then
		startmenu=true 
		startcenario=false
		backy:pause()
		sweet:play()
		ligado=false

	end
	--]]
	-----------------------aqui eu desenho o you win e o you loser----------------------
	if placar.iron>placar.super and fimjogo==true  then
		ironcampeao=true
		startcenario=false
	elseif  placar.iron<placar.super and fimjogo==true  then
		supercampeao=true
		startcenario=false
		
	elseif placar.iron==placar.super and fimjogo==true  then
		empate=true
		startcenario=false
	end
	if ironcampeao==true and startcenario==false then
		love.graphics.draw(ironcampeaoimg,0,0)
	elseif supercampeao==true and startcenario==false then
		love.graphics.draw(supercampeaoimg,0,0)
	elseif empate==true and startcenario==false then
		love.graphics.draw(empateimg,0,0)
	end




end









