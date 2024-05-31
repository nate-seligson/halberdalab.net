function ds = mat2dataset(data,colnames)
    dataset_params = colnames;
    dataset_params(2:end+1) = dataset_params(1:end); dataset_params{1} = data;
    ds = dataset( dataset_params );
end