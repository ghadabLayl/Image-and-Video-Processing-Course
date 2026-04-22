% To get the best results across different images, you'll want to tune a few specific "knobs" in your code. Since image processing is essentially a game of filtering out noise, these parameters act as the "security guards" that decide what gets to be called a license plate.
% 
% Here are the most impactful parameters:
% 
% ---
% 
% ### 1. The `bwareafilt` Count
% * **Location:** `dilatedEdges = bwareafilt(dilatedEdges, 3);`
% * **What it does:** It tells MATLAB how many of the largest objects to keep.
% * **Tweak:**
%     * **Increase it (e.g., 5 or 10):** If your image has a lot of "clutter" (stickers, grills, lights) and the plate is relatively small. This gives your ratio logic more candidates to check.
%     * **Decrease it (e.g., 1 or 2):** If your image is very clean and the plate is obviously the biggest thing.
% 
% ### 2. The `targetRatio` (The "Ideal" Shape)
% * **Location:** `targetRatio = 3.0;`
% * **What it does:** This is the mathematical "perfect" version of a plate.
% * **Tweak:**
%     * **Set to ~2.0:** For "boxy" plates (Motorcycles or standard US plates).
%     * **Set to ~4.5 - 5.0:** For "long" plates (European or Chinese style).
% * **Effect:** The code will prioritize objects that look like the shape you defined.
% 
% ### 3. The Ratio Bounds (The "Square Check")
% * **Location:** `if currentRatio < 1.5 || currentRatio > 6.0`
% * **What it does:** This defines the "Hard Rejection" zone. Anything outside this range is deleted immediately.
% * **Tweak:**
%     * **Increase the lower bound (e.g., 2.0):** If the code keeps accidentally picking up square objects like headlights.
%     * **Decrease the upper bound (e.g., 5.0):** If the code keeps picking up long, skinny things like the car's bumper or the gap between the hood and the frame.
% 
% ### 4. Noise Removal (`bwareaopen`)
% * **Location:** `dilatedEdges = bwareaopen(dilatedEdges, 50);`
% * **What it does:** It deletes any object smaller than $X$ pixels.
% * **Tweak:**
%     * **Increase (e.g., 500):** If your image is high-resolution. Tiny specs of dust or reflections will be ignored, speeding up the code and reducing errors.
%     * **Decrease (e.g., 10):** If the car is very far away in the photo and the plate is tiny.
% 
% ---
% 
% ### Summary Table for Troubleshooting
% 
% | If the code... | Tweak this... | Direction |
% | :--- | :--- | :--- |
% | Picks up a square headlight | **Lower Ratio Bound** | Increase (e.g., from 1.5 to 2.0) |
% | Picks up the long front grill | **Upper Ratio Bound** | Decrease (e.g., from 6.0 to 4.5) |
% | Returns "No Plate Found" | **bwareafilt** | Increase (look at more objects) |
% | Returns a tiny speck of noise | **bwareaopen** | Increase (filter out small stuff) |
% | Picks a rectangle that isn't the plate | **targetRatio** | Match it to your specific plate type |
% 
% ### A Pro Tip on Image Size
% Your original code uses a hardcoded `50` for noise removal. If you change from a $2$-megapixel photo to a $20$-megapixel photo, $50$ pixels will be almost invisible. A more "generalized" way is to base it on the image size:
% `bwareaopen(dilatedEdges, round(numel(I) * 0.0005));`
% This ensures that the "noise filter" scales automatically with your image resolution!
% 
% Are you seeing the code pick up "false positives" (wrong objects) more often, or is it failing to find the plate at all?