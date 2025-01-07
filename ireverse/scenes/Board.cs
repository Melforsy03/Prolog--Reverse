using Godot;
using System;
using System.IO;
using System.IO.Pipes;
public partial class Board : Node2D
{
	private static int PlayerTurn = 1;
	private static bool AnswerReady = true;
	private static StreamWriter swIn = new StreamWriter("../ireverse/in.txt");
	private static StreamReader srOut;
	private static StreamWriter swOut;
    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		if(!AnswerReady){
			srOut = new StreamReader("../ireverse/out.txt");
			string line = srOut.ReadLine();
			srOut.Close();
			GD.Print(line);
			string matrixLine = string.Empty;
			bool firstReaded = false;
			
			foreach(char a in line){
				if(!firstReaded){
					if(a == '1'){
						firstReaded = true;
					}
					else if(a == '0'){
						break;
					}
				}
				else if(firstReaded){
					matrixLine += a;
				}
			}
			if (firstReaded)
			{
                int c = 0;
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
					PlayerTurn = 2;
				}
				else
				{
					PlayerTurn = 1;
				}
				swOut = new StreamWriter("../ireverse/out.txt");
				swOut.WriteLine(0);
				swOut.Close();
                AnswerReady = true;
            }
			
		}
	}
	
	public void ButtonManager(int i)
    {
		if(AnswerReady){
            swIn.WriteLine("1" + PlayerTurn + GetX(i) + GetY(i));
			swIn.Close();
            AnswerReady = false;
		}	
	}
	
	private int GetX(int x){
		while(x > 7){
			x =-8;
		}
		return x;
	}

	private int GetY(int y){
		return y/8;
	}


	private void _on_b_0_pressed(){
        ButtonManager(0);
	}
	private void _on_b_1_pressed(){
		ButtonManager(1);
	}
	private void _on_b_2_pressed(){
		ButtonManager(2);
	}
	private void _on_b_3_pressed(){
		ButtonManager(3);
	}
	private void _on_b_4_pressed(){
		ButtonManager(4);
	}
	private void _on_b_5_pressed(){
		ButtonManager(5);
	}
	private void _on_b_6_pressed(){
		ButtonManager(6);
	}
	private void _on_b_7_pressed(){
		ButtonManager(7);
	}
	private void _on_b_8_pressed(){
		ButtonManager(8);
	}
	private void _on_b_9_pressed(){
		ButtonManager(9);
	}
	private void _on_b_10_pressed(){
		ButtonManager(10);
	}
	private void _on_b_11_pressed(){
		ButtonManager(11);
	}
	private void _on_b_12_pressed(){
		ButtonManager(12);
	}
	private void _on_b_13_pressed(){
		ButtonManager(13);
	}
	private void _on_b_14_pressed(){
		ButtonManager(14);
	}
	private void _on_b_15_pressed(){
		ButtonManager(15);
	}
	private void _on_b_16_pressed(){
		ButtonManager(16);
	}
	private void _on_b_17_pressed(){
		ButtonManager(17);
	}
	private void _on_b_18_pressed(){
		ButtonManager(18);
	}
	private void _on_b_19_pressed(){
		ButtonManager(19);
	}
	private void _on_b_20_pressed(){
		ButtonManager(20);
	}
	private void _on_b_21_pressed(){
		ButtonManager(21);
	}
	private void _on_b_22_pressed(){
		ButtonManager(22);
	}
	private void _on_b_23_pressed(){
		ButtonManager(23);
	}
	private void _on_b_24_pressed(){
		ButtonManager(24);
	}
	private void _on_b_25_pressed(){
		ButtonManager(25);
	}
	private void _on_b_26_pressed(){
		ButtonManager(26);
	}
	private void _on_b_27_pressed(){
		ButtonManager(27);
	}
	private void _on_b_28_pressed(){
		ButtonManager(28);
	}
	private void _on_b_29_pressed(){
		ButtonManager(29);
	}
	private void _on_b_30_pressed(){
		ButtonManager(30);
	}
	private void _on_b_31_pressed(){
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