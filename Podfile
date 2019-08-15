
platform :ios, '12.2'

target 'BoursobookProduction' do
use_frameworks!

  pod 'Firebase'
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Firebase/Auth'

  target 'BoursobookDevelopment' do
    pod 'Firebase'
    pod 'Firebase/Core'
    pod 'Firebase/Database'
    pod 'Firebase/Auth'

    target 'BoursobookDevelopmentFrench' do
      pod 'Firebase'
      pod 'Firebase/Core'
      pod 'Firebase/Database'
      pod 'Firebase/Auth'

      target 'BoursobookTests' do
        inherit! :search_paths
        pod 'Firebase'
        pod 'Firebase/Core'
        pod 'Firebase/Database'
        pod 'Firebase/Auth'
      end
    end
  end
end

#abstract_target 'projet' do

# use_frameworks!
  
# pod 'Firebase'
# pod 'Firebase/Core'
# pod 'Firebase/Database'
# pod 'Firebase/Auth'

# target 'BoursobookProduction' do
    # The target 'production' has its own copies of all 
    # pods from abstract target 'project' (inherited)
#   end
  
# target 'BoursobookDevelopment' do
    # The target 'development' has its own copies of all 
    # pods from abstract target 'project' (inherited)
#   end
  
# target 'BoursobookDevelopmentFrench' do
    # The target 'development' in French has its own copies of all 
    # pods from abstract target 'project' (inherited)
#   end
  
# target 'BoursobookTests' do
    # Pods for testing
    # The target 'unit test' inherit 
#   inherit! :search_paths
#   end
#end
