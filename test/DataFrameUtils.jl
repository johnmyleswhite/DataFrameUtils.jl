module DataFrameUtils
	using DataFrames
	using DataFrameUtils

	# Basic functionality
	f1(a_i, b_j, c_k) = a_i + b_j + c_k
	f2(a_i, b_j, c_k) = [a_i + 1, b_j + 1, c_k + 1]
	f3(a_i, b_j, c_k) = DataFrame(Col1 = a_i - 10,
		                          Col2 = b_j - 10,
		                          Col3 = c_k - 10)
	f4(a_i, b_j, c_k) = DataFrame(Col1 = [a_i - 1, a_i + 1],
		                          Col2 = [b_j - 1, b_j + 1],
		                          Col3 = [c_k - 1, c_k + 1])

	mapcombinations(f1, A = 1:2, B = 3:3, C = 5:7)
	mapcombinations(f2, A = 1:2, B = 3:3, C = 5:7)
	mapcombinations(f3, A = 1:2, B = 3:3, C = 5:7)
	mapcombinations(f4, A = 1:2, B = 3:3, C = 5:7)

	# Scaling
	mapcombinations(f1, A = 1:100, B = 2:101, C = 3:102)
end
