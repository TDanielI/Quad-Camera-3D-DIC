import numpy as np
import cv2
import torch
import torchvision.transforms.functional as TF
# On Kaggle/Colab uncomment the following line:
# !pip install kornia
import kornia as K
import kornia.feature as KF

def load_image(fname):
    img = K.utils.image_to_tensor(cv2.imread(fname), False).float() /255.
    img = K.color.bgr_to_rgb(img)
    return img

def get_fundamental_matrix_kornia(img1, img2, matcher):
    input_dict = {"image0": TF.rgb_to_grayscale(img1), # LofTR works on grayscale images only
    "image1": TF.rgb_to_grayscale(img2)}
    with torch.inference_mode():
        correspondences = matcher(input_dict)
    mkpts0 = correspondences['keypoints0'].cpu().numpy()
    mkpts1 = correspondences['keypoints1'].cpu().numpy()
    print("Number of matches: ", mkpts0.shape[0])
    Fm, _ = cv2.findFundamentalMat(mkpts0, mkpts1, cv2.USAC_MAGSAC, 0.5, 0.999, 100000)
    return Fm, correspondences

if __name__ == "__main__":
    # TODO: Change the following if needed
    # Manually change this:
    img1_path = "/work/yashsb/rel_pose/demo/matterport_1.png"
    img2_path = "/work/yashsb/rel_pose/demo/matterport_2.png"

    # Images
    img1 = load_image(img1_path)
    img2 = load_image(img2_path)

    # Construct a LoFTR matcher
    matcher = KF.LoFTR(pretrained='indoor')
    # Get the fundamental matrix and correspondences from the matcher
    Fm, correspondences = get_fundamental_matrix_kornia(img1, img2, matcher)

    print("Fm", Fm)
    print("Correspondences", correspondences)