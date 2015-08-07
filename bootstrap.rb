node.reverse_merge!({
  role: 'yum-repositories'
})

module RecipeHelper
  def include_cookbook(name)
    include_recipe File.join(__dir__, "cookbooks", name, "default.rb")
  end
  def include_role(name)
    include_recipe File.join(__dir__, "roles", name, "default.rb")
  end
end

Itamae::Recipe::EvalContext.include(RecipeHelper)

include_recipe File.join("roles", node[:role], "default.rb")
