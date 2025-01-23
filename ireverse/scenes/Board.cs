using Godot;
using System;
using System.IO;
using System.IO.Pipes;
public partial class Board : Node2D
{
	private static int PlayerTurn = 1;
	private static bool AnswerReady = true;
	private static bool started = false;
	private static int Difficulty = 0;
	private static int GameMode = 0;
	private static int Winner = 0;
	private static int Score = 0;
	private static bool AIPlayed = false;

	
	private static StreamWriter swStart;

    private static StreamWriter swIn;

    private static StreamReader srEnd;
	private static StreamWriter swEnd;
	
	private static StreamReader srOut;
	private static StreamWriter swOut;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		if (started)
		{	if(GameMode == 1 && PlayerTurn == 2 && AnswerReady)
			{
                try
                {
                    swIn = new StreamWriter("../ireverse/in.txt");
                    swIn.WriteLine("1" + PlayerTurn + "00");
                    swIn.Close();
                    swIn = null;
                    AnswerReady = false;
					AIPlayed = true;
                }
                catch (Exception ex)
                {
                }   
            }

			if (!AnswerReady)
			{
				string line = string.Empty;
                try
                {
                    srOut = new StreamReader("../ireverse/out.txt");
                    line = srOut.ReadLine();
                    srOut.Close();
                    srOut = null;
                }
                catch (Exception ex)
                {
                   
                }

                
				
				string matrixLine = string.Empty;
				bool firstReaded = false;

				foreach (char a in line)
				{
					if (!firstReaded)
					{
						if (a == '1')
						{
							firstReaded = true;
							GetNode<TextEdit>("../board/info").Hide();
                            GD.Print(line);
                        }
						else if (a == '0')
						{
							break;
						}else if(a == '2')
						{
                            GetNode<TextEdit>("../board/info").Text = "Opcion no valida";
							GetNode<AudioStreamPlayer2D>("../board/wrongSound").Play();
                            GetNode<TextEdit>("../board/info").Show();
                            GD.Print(line);
                            try
                            {
                                swOut = new StreamWriter("../ireverse/out.txt");
                                swOut.WriteLine("0");
                                swOut.Close();
                                swOut = null;
                                AnswerReady = true;
                            }
                            catch (Exception ex)
                            {
                            }
                            
                            break;
                        }else if(a == '3')
						{
                            GD.Print(line);
                            try
                            {
                                swOut = new StreamWriter("../ireverse/out.txt");
                                swOut.WriteLine("0");
                                swOut.Close();
                                swOut = null;
                                AnswerReady = true;
                            }
                            catch (Exception ex)
                            {
                            }
							GetNode<TextEdit>("info").Text = "El jugador " + PlayerTurn + " pasa turno.";
							GetNode<TextEdit>("info").Show();
                            if (PlayerTurn == 1)
                            {
                                PlayerTurn = 2;
                                Image image = new Image();
                                ImageTexture Photo = new ImageTexture();
                                image.Load(@"../ireverse/images/board2.png");
                                Photo = ImageTexture.CreateFromImage(image);
								GetNode<Sprite2D>("boradBackground").Texture = Photo;
                            }
                            else
                            {
                                PlayerTurn = 1;
                                Image image = new Image();
                                ImageTexture Photo = new ImageTexture();
                                image.Load(@"../ireverse/images/board.png");
                                Photo = ImageTexture.CreateFromImage(image);
                                GetNode<Sprite2D>("boradBackground").Texture = Photo;
                            }


                            break;
                        }
					}
					else if (firstReaded)
					{
						matrixLine += a;
					}
				}
				if (firstReaded)
				{
					int c = 0;
					if(AIPlayed)
					{
						GetNode<AudioStreamPlayer2D>("../board/tileSound").Play();
						AIPlayed = false;
					}
					foreach (char a in matrixLine)
					{

						Image image = new Image();
						string p = a.ToString();
						if (int.Parse(p) == 0)
						{
							image.Load(@"../ireverse/images/blank.png");
						}
						else if (int.Parse(p) == 1)
						{
							image.Load(@"../ireverse/images/red.png");
						}
						else if (int.Parse(p) == 2)
						{
							image.Load(@"../ireverse/images/blue.png");
						}
						ImageTexture Photo = ImageTexture.CreateFromImage(image);
						GetNode<Button>("b" + c).SetButtonIcon(Photo);
						c++;
					}
					
					if (PlayerTurn == 1)
					{
                        Image image = new Image();
                        ImageTexture Photo = new ImageTexture();
                        image.Load(@"../ireverse/images/board2.png");
                        Photo = ImageTexture.CreateFromImage(image);
                        GetNode<Sprite2D>("boradBackground").Texture = Photo;
                        PlayerTurn = 2;
					}
					else
					{
                        Image image = new Image();
                        ImageTexture Photo = new ImageTexture();
                        image.Load(@"../ireverse/images/board.png");
                        Photo = ImageTexture.CreateFromImage(image);
                        GetNode<Sprite2D>("boradBackground").Texture = Photo;
                        PlayerTurn = 1;
					}
                    swOut = new StreamWriter("../ireverse/out.txt");
                    swOut.WriteLine("0");
                    swOut.Close();
                    swOut = null;
                    AnswerReady = true;     
				}
			}
            string end = string.Empty;
            try
            {
                srEnd = new StreamReader("../ireverse/end.txt");
                end = srEnd.ReadLine();
                srEnd.Close();
                srEnd = null;
            }
            catch (Exception ex)
            {
            }

            bool first = false;
            bool second = false;
            string score = string.Empty;
            foreach (char a in end)
            {
                
                if (int.Parse(a.ToString()) == 1 && !first)
                {
                 
                    first = true;
                }
                else if (!second && first)
                {
                  
                    second = true;
                    Winner = int.Parse(a.ToString());
                }
                else if (first && second)
                {
               
                    score += a;
                }
            }
            if (first)
            {
              
                swEnd = new StreamWriter("../ireverse/end.txt");
                swEnd.WriteLine("0");
                swEnd.Close();
                swEnd = null;
                Score = int.Parse(score);
                EndGame();
            }
        }
		else
		{
			if (GetNode<OptionButton>("../menu/GameModeButton").Selected == 1)
			{
				GetNode<OptionButton>("../menu/DificultyButton").Disabled = false;
			}
			else
			{
				GetNode<OptionButton>("../menu/DificultyButton").Disabled = true;
			}

		}

        
		
    }
		public void ButtonManager(int i)
		{	
			if (AnswerReady) 
			{
				bool worked = true;
				try
				{
					swIn = new StreamWriter("../ireverse/in.txt");
					swIn.WriteLine("1" + PlayerTurn + GetX(i) + GetY(i));
					GD.Print(GetX(i), GetY(i));
					swIn.Close();
					swIn = null;
					AnswerReady = false;
				}
				catch (Exception ex)
				{
					worked = false;
				}
				if(!worked)
				{
					ButtonManager(i);
				}
				
				GetNode<AudioStreamPlayer2D>("../board/tileSound").Play();
				
				

			}
		}
		
		private void StartGame()
		{
			GetNode<AudioStreamPlayer2D>("../buttonSound").Play();
			swStart = new StreamWriter("../ireverse/start.txt");
			swStart.WriteLine("1" + GameMode + Difficulty);
			swStart.Close();
			swStart = null;
			started = true;
		}
		private void EndGame()
		{
			started = false;
			if(Winner != 3)
			{
				GetNode<TextEdit>("../winScreen/winbackground/winner").Text = "Player " + Winner + " has won!";
				if(Winner == 1)
				{
					GetNode<AudioStreamPlayer2D>("../winScreen/winSound").Play();
				}
				else
				{
					GetNode<AudioStreamPlayer2D>("../winScreen/defeatSound").Play();
				}
			}
			else
			{
				GetNode<TextEdit>("../winScreen/winner").Text = "Draw";
				GetNode<AudioStreamPlayer2D>("../winScreen/drawSound").Play();

			}
			
			GetNode<TextEdit>("../winScreen/winbackground/score").Text = "Score: " + Score + ".";
			GetNode<Node2D>("../winScreen").Show();
		}
		private int GetX(int x) {
			
			return x / 8;
		}

		private int GetY(int y) {
			while (y > 7)
			{
				y+= -8;
			}
			return y;
		}
		
		private void _on_back_button_pressed()
		{
			try
			{
				swIn = new StreamWriter("../ireverse/in.txt");
				swIn.WriteLine("2");

				swIn.Close();
				swIn = null;
				EndGame();
			}
			catch
			{
				_on_back_button_pressed();
			}
			
			
		}

        private void _on_play_again_button_pressed()
		{
			GetNode<AudioStreamPlayer2D>("../buttonSound").Play();
			started = false;
			Winner = 0;
			Score = 0;
			PlayerTurn = 1;
			GameMode = 0;
			AnswerReady = true;
			Image image = new Image();
			ImageTexture Photo = new ImageTexture();
			for (int i = 0; i < 64; i++)
			{	
				if(i == 27 || i == 36)
				{
					image.Load(@"../ireverse/images/blue.png");
					Photo = ImageTexture.CreateFromImage(image);
					GetNode<Button>("b" + i).SetButtonIcon(Photo);
				
				}
				else if(i == 28 || i == 35)
				{
					image.Load(@"../ireverse/images/red.png");
					Photo = ImageTexture.CreateFromImage(image);
					GetNode<Button>("b" + i).SetButtonIcon(Photo);
					
				}
				else
				{
					image.Load(@"../ireverse/images/blank.png");
					Photo = ImageTexture.CreateFromImage(image);
					GetNode<Button>("b" + i).SetButtonIcon(Photo);
				}
				
			}
			GetNode<Node2D>("../board").Hide();
			GetNode<Node2D>("../winScreen").Hide();
			GetNode<Node2D>("../menu").Show();
		}

		private void _on_start_button_pressed()
		{
			GetNode<AudioStreamPlayer2D>("../buttonSound").Play();
			GameMode = GetNode<OptionButton>("../menu/GameModeButton").Selected;
			if (GameMode == 0)
			{
				GetNode<Node2D>("../menu").Hide();
				GetNode<Node2D>("../board").Show();
				Difficulty = 0;
				StartGame();
			} else if (GameMode == 1)
			{
				GetNode<Node2D>("../menu").Hide();
				GetNode<Node2D>("../board").Show();
				Difficulty = GetNode<OptionButton>("../menu/DificultyButton").Selected;
				StartGame();
			}
		}


		private void _on_b_0_pressed() {
			ButtonManager(0);
		}
		private void _on_b_1_pressed() {
			ButtonManager(1);
		}
		private void _on_b_2_pressed() {
			ButtonManager(2);
		}
		private void _on_b_3_pressed() {
			ButtonManager(3);
		}
		private void _on_b_4_pressed() {
			ButtonManager(4);
		}
		private void _on_b_5_pressed() {
			ButtonManager(5);
		}
		private void _on_b_6_pressed() {
			ButtonManager(6);
		}
		private void _on_b_7_pressed() {
			ButtonManager(7);
		}
		private void _on_b_8_pressed() {
			ButtonManager(8);
		}
		private void _on_b_9_pressed() {
			ButtonManager(9);
		}
		private void _on_b_10_pressed() {
			ButtonManager(10);
		}
		private void _on_b_11_pressed() {
			ButtonManager(11);
		}
		private void _on_b_12_pressed() {
			ButtonManager(12);
		}
		private void _on_b_13_pressed() {
			ButtonManager(13);
		}
		private void _on_b_14_pressed() {
			ButtonManager(14);
		}
		private void _on_b_15_pressed() {
			ButtonManager(15);
		}
		private void _on_b_16_pressed() {
			ButtonManager(16);
		}
		private void _on_b_17_pressed() {
			ButtonManager(17);
		}
		private void _on_b_18_pressed() {
			ButtonManager(18);
		}
		private void _on_b_19_pressed() {
			ButtonManager(19);
		}
		private void _on_b_20_pressed() {
			ButtonManager(20);
		}
		private void _on_b_21_pressed() {
			ButtonManager(21);
		}
		private void _on_b_22_pressed() {
			ButtonManager(22);
		}
		private void _on_b_23_pressed() {
			ButtonManager(23);
		}
		private void _on_b_24_pressed() {
			ButtonManager(24);
		}
		private void _on_b_25_pressed() {
			ButtonManager(25);
		}
		private void _on_b_26_pressed() {
			ButtonManager(26);
		}
		private void _on_b_27_pressed() {
			ButtonManager(27);
		}
		private void _on_b_28_pressed() {
			ButtonManager(28);
		}
		private void _on_b_29_pressed() {
			ButtonManager(29);
		}
		private void _on_b_30_pressed() {
			ButtonManager(30);
		}
		private void _on_b_31_pressed() {
			ButtonManager(31);
		}
		private void _on_b_32_pressed()
		{
			ButtonManager(32);
		}
		private void _on_b_33_pressed()
		{
			ButtonManager(33);
		}
		private void _on_b_34_pressed()
		{
			ButtonManager(34);
		}
		private void _on_b_35_pressed()
		{
			ButtonManager(35);
		}
		private void _on_b_36_pressed()
		{
			ButtonManager(36);
		}
		private void _on_b_37_pressed()
		{
			ButtonManager(37);
		}
		private void _on_b_38_pressed()
		{
			ButtonManager(38);
		}
		private void _on_b_39_pressed()
		{
			ButtonManager(39);
		}
		private void _on_b_40_pressed()
		{
			ButtonManager(40);
		}
		private void _on_b_41_pressed()
		{
			ButtonManager(41);
		}
		private void _on_b_42_pressed()
		{
			ButtonManager(42);
		}
		private void _on_b_43_pressed()
		{
			ButtonManager(43);
		}
		private void _on_b_44_pressed()
		{
			ButtonManager(44);
		}
		private void _on_b_45_pressed()
		{
			ButtonManager(45);
		}
		private void _on_b_46_pressed()
		{
			ButtonManager(46);
		}
		private void _on_b_47_pressed()
		{
			ButtonManager(47);
		}
		private void _on_b_48_pressed()
		{
			ButtonManager(48);
		}
		private void _on_b_49_pressed()
		{
			ButtonManager(49);
		}
		private void _on_b_50_pressed()
		{
			ButtonManager(50);
		}
		private void _on_b_51_pressed()
		{
			ButtonManager(51);
		}
		private void _on_b_52_pressed()
		{
			ButtonManager(52);
		}
		private void _on_b_53_pressed()
		{
			ButtonManager(53);
		}
		private void _on_b_54_pressed()
		{
			ButtonManager(54);
		}
		private void _on_b_55_pressed()
		{
			ButtonManager(55);
		}
		private void _on_b_56_pressed()
		{
			ButtonManager(56);
		}
		private void _on_b_57_pressed()
		{
			ButtonManager(57);
		}
		private void _on_b_58_pressed()
		{
			ButtonManager(58);
		}
		private void _on_b_59_pressed()
		{
			ButtonManager(59);
		}
		private void _on_b_60_pressed()
		{
			ButtonManager(60);
		}
		private void _on_b_61_pressed()
		{
			ButtonManager(61);
		}
		private void _on_b_62_pressed()
		{
			ButtonManager(62);
		}
		private void _on_b_63_pressed()
		{
			ButtonManager(63);
		}
	}
