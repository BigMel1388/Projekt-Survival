using Godot;
using System;

public partial class CharacterBody3d : CharacterBody3D
{
	public const float Speed = 5.0f;
	public const float JumpVelocity = 4.5f;

	[Export]
	public Node3D Head;

	[Export]
	public Camera3D Camera;
	public float sensitivityx = 0.1f / 10000.0f; // 1/100000
	public float sensitivityy = 0.1f / 10000.0f; // 1/100000


	public CharacterBody3d()
	{
	}


	public override void _Ready()
	{
		Input.MouseMode = Input.MouseModeEnum.Captured;
	}

	public override void _Process(double delta)
	{
		// Rotate the head and camera.
		Vector2 mouseMovement = Input.GetLastMouseVelocity();
		RotateY(-mouseMovement.X * sensitivityx);
		Head.RotateX(-mouseMovement.Y * sensitivityy);

		// Clamp the head rotation to prevent flipping.
		Vector3 headRotation = Head.RotationDegrees;
		headRotation.X = Mathf.Clamp(headRotation.X, -90, 90);
		Head.RotationDegrees = headRotation;
	}

	public override void _PhysicsProcess(double delta)
	{
		Vector3 velocity = Velocity;

		// Add the gravity.
		if (!IsOnFloor())
		{
			velocity += GetGravity() * (float)delta;
		}

		// Handle Jump.
		if (Input.IsActionJustPressed("movement_jump") && IsOnFloor())
		{
			velocity.Y = JumpVelocity;
		}

		// Get the input direction and handle the movement/deceleration.
		// As good practice, you should replace UI actions with custom gameplay actions.
		Vector2 inputDir = Input.GetVector("movement_left", "movement_right", "movement_up", "movement_down");
		Vector3 direction = (Transform.Basis * new Vector3(inputDir.X, 0, inputDir.Y)).Normalized();
		if (direction != Vector3.Zero)
		{
			velocity.X = direction.X * Speed;
			velocity.Z = direction.Z * Speed;
		}
		else
		{
			velocity.X = Mathf.MoveToward(Velocity.X, 0, Speed);
			velocity.Z = Mathf.MoveToward(Velocity.Z, 0, Speed);
		}

		Velocity = velocity;
		MoveAndSlide();
	}
}

//! My mom is cleaning up the room, so i cant lmaoo