def partition_classes(X, y, split_attribute, split_val):
    """
    Inputs:
    - X               : (N,D) list containing all data attributes
    - y               : a list of labels
    - split_attribute : column index of the attribute to split on
    - split_val       : either a numerical or categorical value to divide the split_attribute

    TODO: Partition the data(X) and labels(y) based on the split value - BINARY SPLIT.

    Example:

    X = [[3, 'aa', 10],                 y = [1,
         [1, 'bb', 22],                      1,
         [2, 'cc', 28],                      0,
         [5, 'bb', 32],                      0,
         [4, 'cc', 32]]                      1]

    Here, columns 0 and 2 represent numeric attributes, while column 1 is a categorical attribute.

    Consider the case where we call the function with split_attribute = 0 (the index of attribute) and split_val = 3 (the value of attribute).
    Then we divide X into two lists - X_left, where column 0 is <= 3 and X_right, where column 0 is > 3.

    X_left = [[3, 'aa', 10],                 y_left = [1,
              [1, 'bb', 22],                           1,
              [2, 'cc', 28]]                           0]

    X_right = [[5, 'bb', 32],                y_right = [0,
               [4, 'cc', 32]]                           1]

    Consider another case where we call the function with split_attribute = 1 and split_val = 'bb'
    Then we divide X into two lists, one where column 1 is 'bb', and the other where it is not 'bb'.

    X_left = [[1, 'bb', 22],                 y_left = [1,
              [5, 'bb', 32]]                           0]

    X_right = [[3, 'aa', 10],                y_right = [1,
               [2, 'cc', 28],                           0,
               [4, 'cc', 32]]                           1]

    Return in this order: (X_left, X_right, y_left, y_right)
    """
    if isinstance(split_val, basestring):
        X_left = X[np.where(X[:,split_attribute] == split_val)]
        y_left = y[np.where(X[:,split_attribute] == split_val)]
        X_right = X[np.where(X[:,split_attribute] != split_val)]
        y_right = y[np.where(X[:,split_attribute] != split_val)]
        return X_left, X_right, y_left, y_right
    else:
        X_left = X[np.where(X[:,split_attribute] <= split_val)]
        y_left = y[np.where(X[:,split_attribute] <= split_val)]
        X_right = X[np.where(X[:,split_attribute] > split_val)]
        y_right = y[np.where(X[:,split_attribute] > split_val)]
        return X_left, X_right, y_left, y_right

    # Delete this line when you implement the function
    #raise NotImplementedError




def find_best_split(X, y, split_attribute):
    """Inputs:
        - X               : (N,D) list containing all data attributes
        - y               : a list array of labels
        - split_attribute : Column of X on which to split

    TODO: Compute and return the optimal split value for a given attribute, along with the corresponding information gain

    Note: You will need the functions information_gain and partition_classes to write this function

    Example:

        X = [[3, 'aa', 10],                 y = [1,
             [1, 'bb', 22],                      1,
             [2, 'cc', 28],                      0,
             [5, 'bb', 32],                      0,
             [4, 'cc', 32]]                      1]

        split_attribute = 0

        Starting entropy: 0.971

        Calculate information gain at splits:
           split_val = 1  -->  info_gain = 0.17
           split_val = 2  -->  info_gain = 0.02
           split_val = 3  -->  info_gain = 0.02
           split_val = 4  -->  info_gain = 0.32
           split_val = 5  -->  info_gain = 0.

       best_split_val = 4; info_gain = .32;
    """
    max_gain = 0
    split_val = None
    for row in X:
        X_left, X_right, y_left, y_right = partition_classes(X, y, split_attribute, row[split_attribute])
        info_gain = information_gain(y, [y_left, y_right])
        if info_gain > max_gain:
            max_gain = info_gain
            split_val = row[split_attribute]
    return split_val, max_gain


    # Delete this line when you implement the function
    #raise NotImplementedError






def find_best_feature(X, y):
    """
    Inputs:
        - X: (N,D) list containing all data attributes
        - y : a list of labels

    TODO: Compute and return the optimal attribute to split on and optimal splitting value

    Note: If two features tie, choose one of them at random

    Example:

        X = [[3, 'aa', 10],                 y = [1,
             [1, 'bb', 22],                      1,
             [2, 'cc', 28],                      0,
             [5, 'bb', 32],                      0,
             [4, 'cc', 32]]                      1]

        split_attribute = 0

        Starting entropy: 0.971

        Calculate information gain at splits:
           feature 0:  -->  info_gain = 0.32
           feature 1:  -->  info_gain = 0.17
           feature 2:  -->  info_gain = 0.42

        best_split_feature: 2 best_split_val: 22
    """
    opt_attr = 0
    opt_val = None
    max_gain = 0
    for i in range(X.shape[1]):
        split_val, gain = find_best_split(X, y, i)
        if gain > max_gain:
            gain = max_gain
            opt_attr = i
            opt_val = split_val
    return opt_attr, opt_val

    # Delete this line when you implement the function
    #raise NotImplementedError

