package globals;

import flixel.util.FlxColor;
import openfl.display.BitmapData;
import flash.geom.Rectangle;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.math.FlxMatrix;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxBitmapDataPool;
import flixel.util.FlxCollision;

class CustomCollision
{
	static var pointA:FlxPoint = new FlxPoint();
	static var pointB:FlxPoint = new FlxPoint();
	static var centerA:FlxPoint = new FlxPoint();
	static var centerB:FlxPoint = new FlxPoint();
	static var matrixA:FlxMatrix = new FlxMatrix();
	static var matrixB:FlxMatrix = new FlxMatrix();
	static var testMatrix:FlxMatrix = new FlxMatrix();
	static var boundsA:FlxRect = new FlxRect();
	static var boundsB:FlxRect = new FlxRect();
	static var intersect:FlxRect = new FlxRect();
	static var flashRect:Rectangle = new Rectangle();

	/**
	 * A Collision check between two FlxSprites: the first sprite it will take into account the pixels of the sprite, using rotations and scale, etc, 
	 * but will ONLY look at the Hitbox (width/height + offset) of the second sprite. It will do a bounds check first, and if that passes it will run a
	 * pixel perfect match on the intersecting area. May be slow, so use it sparingly.
	 *
	 * @param	Contact			The first FlxSprite to test against - this sprite will use its pixels
	 * @param	Target			The second FlxSprite to test again, sprite order is IMPORTANT: this sprite will ONLY use its hitbox (width/height + offset)
	 * @param	AlphaTolerance	The tolerance value above which alpha pixels are included. Default to 1 (anything that is not fully invisible).
	 * @param	Camera			If the collision is taking place in a camera other than FlxG.camera (the default/current) then pass it here
	 * @return	Whether the sprites collide
	 */
	@:access(flixel.animation.FlxAnimationController._prerotated)
	public static function pixelPerfectHitboxCheck(Contact:FlxSprite, Target:FlxSprite, AlphaTolerance:Int = 1, ?Camera:FlxCamera):Bool
	{
		// if either of the angles are non-zero, consider the angles of the first sprite in the check
		var advanced = (Contact.angle != 0 && Contact.animation._prerotated == null) || Contact.scale.x != 1 || Contact.scale.y != 1;

		Contact.getScreenBounds(boundsA, Camera);
		Target.getScreenBounds(boundsB, Camera);

		boundsA.intersection(boundsB, intersect.set());

		if (intersect.isEmpty || intersect.width < 1 || intersect.height < 1)
		{
			return false;
		}

		//	Thanks to Chris Underwood for helping with the translate logic :)
		matrixA.identity();
		matrixA.translate(-(intersect.x - boundsA.x), -(intersect.y - boundsA.y));

		matrixB.identity();
		matrixB.translate(-(intersect.x - boundsB.x), -(intersect.y - boundsB.y));

		Contact.drawFrame();
		Target.drawFrame();

		var testA:BitmapData = Contact.framePixels;

		var overlapWidth:Int = Std.int(intersect.width);
		var overlapHeight:Int = Std.int(intersect.height);

		// More complicated case, if either of the sprites is rotated
		if (advanced)
		{
			testMatrix.identity();

			// translate the matrix to the center of the sprite
			testMatrix.translate(-Contact.origin.x, -Contact.origin.y);

			// rotate the matrix according to angle
			testMatrix.rotate(Contact.angle * FlxAngle.TO_RAD);
			testMatrix.scale(Contact.scale.x, Contact.scale.y);

			// translate it back!
			testMatrix.translate(boundsA.width / 2, boundsA.height / 2);

			// prepare an empty canvas
			var testA2:BitmapData = FlxBitmapDataPool.get(Math.floor(boundsA.width), Math.floor(boundsA.height), true, FlxColor.TRANSPARENT, false);

			// plot the sprite using the matrix
			testA2.draw(testA, testMatrix, null, null, null, false);
			testA = testA2;
		}

		boundsA.x = Std.int(-matrixA.tx);
		boundsA.y = Std.int(-matrixA.ty);
		boundsA.width = overlapWidth;
		boundsA.height = overlapHeight;

		boundsB.x = Std.int(-matrixB.tx);
		boundsB.y = Std.int(-matrixB.ty);
		boundsB.width = overlapWidth;
		boundsB.height = overlapHeight;

		boundsA.copyToFlash(flashRect);
		var pixelsA = testA.getPixels(flashRect);

		boundsB.copyToFlash(flashRect);

		var hit = false;

		// Analyze overlapping area of BitmapDatas to check for a collision (alpha values >= AlphaTolerance)
		var alphaA:Int = 0;
		var alphaIdx:Int = 0;
		var overlapPixels:Int = overlapWidth * overlapHeight;

		// check even pixels
		for (i in 0...Math.ceil(overlapPixels / 2))
		{
			alphaIdx = i << 3;
			pixelsA.position = alphaIdx;
			alphaA = pixelsA.readUnsignedByte();

			if (alphaA >= AlphaTolerance)
			{
				hit = true;
				break;
			}
		}

		if (!hit)
		{
			// check odd pixels
			for (i in 0...overlapPixels >> 1)
			{
				alphaIdx = (i << 3) + 4;
				pixelsA.position = alphaIdx;
				alphaA = pixelsA.readUnsignedByte();

				if (alphaA >= AlphaTolerance)
				{
					hit = true;
					break;
				}
			}
		}

		if (advanced)
		{
			FlxBitmapDataPool.put(testA);
		}

		return hit;
	}
	/**
	 * This is used to check how much of a tile is covered by a sprite. 
	 *
	 * @param	Overlapper			The first FlxSprite to test against - this sprite will use its pixels
	 * @param	AreaToCheckPercentCoverage			The second FlxSprite to test again, sprite order is IMPORTANT: this sprite will ONLY use its hitbox (width/height + offset)
	 * @param	AlphaTolerance	The tolerance value above which alpha pixels are included. Default to 1 (anything that is not fully invisible).
	 * @param	Camera			If the collision is taking place in a camera other than FlxG.camera (the default/current) then pass it here
	 * @return	Whether the sprites collide
	 */
	@:access(flixel.animation.FlxAnimationController._prerotated)
	public static function percentGraphicOverlapsTile(Overlapper:FlxSprite, AreaToCheckPercentCoverage:FlxSprite, AlphaTolerance:Int = 1,
			?Camera:FlxCamera):PercentCoverageData
	{
		var matchingPixels:Int = 0;
		var totalPixelsA:Int = 0;
		var totalPixelsB:Int = 0;

		// if either of the angles are non-zero, consider the angles of the first sprite in the check
		var advanced = (Overlapper.angle != 0 && Overlapper.animation._prerotated == null)
			|| Overlapper.scale.x != 1
			|| Overlapper.scale.y != 1;

		Overlapper.getScreenBounds(boundsA, Camera);
		AreaToCheckPercentCoverage.getScreenBounds(boundsB, Camera);

		boundsA.intersection(boundsB, intersect.set());

		if (intersect.isEmpty || intersect.width < 1 || intersect.height < 1)
		{
			return {
				percentOfAsPixelsWhichOverlapBsPixels: 0,
				percentOfBsPixelsWhichOverlapAsPixels: 0,
				totalPixelsA: 0,
				totalPixelsB: 0,
				matchingPixels: 0
			}
		}

		//	Thanks to Chris Underwood for helping with the translate logic :)
		matrixA.identity();
		matrixA.translate(-(intersect.x - boundsA.x), -(intersect.y - boundsA.y));

		matrixB.identity();
		matrixB.translate(-(intersect.x - boundsB.x), -(intersect.y - boundsB.y));

		Overlapper.drawFrame();
		AreaToCheckPercentCoverage.drawFrame();

		var testA:BitmapData = Overlapper.framePixels;

		var overlapWidth:Int = Std.int(intersect.width);
		var overlapHeight:Int = Std.int(intersect.height);

		// More complicated case, if either of the sprites is rotated
		if (advanced)
		{
			testMatrix.identity();

			// translate the matrix to the center of the sprite
			testMatrix.translate(-Overlapper.origin.x, -Overlapper.origin.y);

			// rotate the matrix according to angle
			testMatrix.rotate(Overlapper.angle * FlxAngle.TO_RAD);
			testMatrix.scale(Overlapper.scale.x, Overlapper.scale.y);

			// translate it back!
			testMatrix.translate(boundsA.width / 2, boundsA.height / 2);

			// prepare an empty canvas
			var testA2:BitmapData = FlxBitmapDataPool.get(Math.floor(boundsA.width), Math.floor(boundsA.height), true, FlxColor.TRANSPARENT, false);

			// plot the sprite using the matrix
			testA2.draw(testA, testMatrix, null, null, null, false);
			testA = testA2;
		}

		boundsA.x = Std.int(-matrixA.tx);
		boundsA.y = Std.int(-matrixA.ty);
		boundsA.width = overlapWidth;
		boundsA.height = overlapHeight;

		boundsB.x = Std.int(-matrixB.tx);
		boundsB.y = Std.int(-matrixB.ty);
		boundsB.width = overlapWidth;
		boundsB.height = overlapHeight;

		boundsA.copyToFlash(flashRect);
		var pixelsA = testA.getPixels(flashRect);

		boundsB.copyToFlash(flashRect);

		var hit = false;

		// Analyze overlapping area of BitmapDatas to check for a collision (alpha values >= AlphaTolerance)
		var alphaA:Int = 0;
		var alphaIdx:Int = 0;
		var overlapPixels:Int = overlapWidth * overlapHeight;

		// check even pixels
		// Single loop to check all pixels
		for (i in 0...overlapPixels)
		{
			alphaIdx = i << 2; // Adjusting index for RGBA
			pixelsA.position = alphaIdx;
			alphaA = pixelsA.readUnsignedByte();

			if (alphaA >= AlphaTolerance)
			{
				matchingPixels++;
			}
		}
		// total pixels should be the total number of pixels in the Overlapper sprite that meet the alpha tolerance. that alpha tolerance is 0.0 to 1.0
		for (i in 0...testA.width)
		{
			for (j in 0...testA.height)
			{
				var p = testA.getPixel32(i, j);
				if (p != 0)
				{
					totalPixelsA++;
				}
			}
		}

		// total pixels should be the total number of pixels in the AreaToCheckPercentCoverage sprite that are not transparent
		for (i in 0...AreaToCheckPercentCoverage.framePixels.width)
		{
			for (j in 0...AreaToCheckPercentCoverage.framePixels.height)
			{
				var p = AreaToCheckPercentCoverage.framePixels.getPixel32(i, j);
				if (p != 0)
				{
					totalPixelsB++;
				}
			}
		}

		// Return the ratio of matching pixels to total pixels
		var percentOfAsPixelsWhichOverlapBsPixels:Float = (totalPixelsA > 0) ? (matchingPixels / totalPixelsA) : 0;
		var percentOfBsPixelsWhichOverlapAsPixels:Float = (totalPixelsB > 0) ? (matchingPixels / totalPixelsB) : 0;

		if (advanced)
		{
			FlxBitmapDataPool.put(testA);
		}

		return {
			percentOfAsPixelsWhichOverlapBsPixels: percentOfAsPixelsWhichOverlapBsPixels,
			percentOfBsPixelsWhichOverlapAsPixels: percentOfBsPixelsWhichOverlapAsPixels,
			totalPixelsA: totalPixelsA,
			totalPixelsB: totalPixelsB,
			matchingPixels: matchingPixels
		}
	}
}

typedef PercentCoverageData =
{
	percentOfAsPixelsWhichOverlapBsPixels:Float,
	percentOfBsPixelsWhichOverlapAsPixels:Float,
	totalPixelsA:Int,
	totalPixelsB:Int,
	matchingPixels:Int
}