
#include <Rcpp.h>
#include <cmath>

//returns the minium value in a NumericVector
double minElem(const Rcpp::NumericVector& elems)
{
  std::size_t vecLen = elems.size();
  double min = elems[0];
  
  for(std::size_t i = 0; i < vecLen; i++)
    if(elems[i] < min)
      min = elems[i];
  
  return min;
}

//returns the maxium value in a NumericVector
double maxElem(const Rcpp::NumericVector& elems)
{
  std::size_t vecLen = elems.size();
  double max = elems[0];
  
  for(std::size_t i = 0; i < vecLen; i++)
    if(elems[i] > max)
      max = elems[i];
    
    return max;
}

//returns the minium range between two values in a NumericVector
// [[Rcpp::export]]
double getMinRange(Rcpp::NumericVector vec)
{
  std::size_t vecLen = vec.size();
  double minRange = std::abs(maxElem(vec) - minElem(vec));
  double curRange = 0;
  
  for(std::size_t i = 0; i < vecLen; i++)
  {
    for(std::size_t j = 0; j < vecLen; j++)
    {
      if(i == j)
        continue;
      curRange = std::abs(vec[i] - vec[j]);
      if(curRange < minRange)
        minRange = curRange;
    }//end of for j
  }//end of for i
  
  return minRange;
}

// [[Rcpp::export]]
Rcpp::NumericVector binValues(unsigned int numInBin, unsigned int numValues)
{
  Rcpp::NumericVector ret;
  unsigned int binNumber = 0;
  unsigned int countInBin = 0;
  
  for(unsigned int i = 0; i < numValues; i++)
  {
    if(countInBin % numInBin == 0)
      binNumber++;
    ret.push_back(binNumber);
    countInBin++;
  }
  
  return ret;
}
